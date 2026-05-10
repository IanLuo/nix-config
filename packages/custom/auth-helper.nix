{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "auth-helper";
  runtimeInputs = with pkgs; [ curl jq coreutils ];
  text = ''
    AUTH_DIR="''${AUTH_HELPER_DIR:-$HOME/.config/auth-helper}"
    SERVICES_DIR="$AUTH_DIR/services"
    TOKENS_FILE="$AUTH_DIR/tokens.json"

    ensure_dirs() {
      mkdir -p "$SERVICES_DIR"
      [ -f "$TOKENS_FILE" ] || echo '{}' > "$TOKENS_FILE"
    }

    urlencode() {
      local raw="$1"
      local encoded=""
      local pos c o
      for ((pos = 0; pos < ''${#raw}; pos++)); do
        c="''${raw:$pos:1}"
        case "$c" in
          [a-zA-Z0-9.~_-]) encoded+="$c" ;;
          *) printf -v o '%%%02X' "'$c"; encoded+="$o" ;;
        esac
      done
      printf '%s' "$encoded"
    }

    generate_code_verifier() {
      openssl rand -base64 48 | tr -d '=' | tr '/+' '_-' | head -c 64
    }

    generate_code_challenge() {
      printf '%s' "$1" | openssl dgst -sha256 -binary | base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n'
    }

    cmd_list() {
      ensure_dirs
      if [ -z "$(ls -A "$SERVICES_DIR" 2>/dev/null)" ]; then
        echo "No services configured."
        echo "Add service configs to $SERVICES_DIR/<name>.json"
        echo "Each file: { \"type\": \"basic|bearer|oauth2\", \"base_url\": \"...\", ... }"
        return
      fi
      for f in "$SERVICES_DIR"/*.json; do
        local name
        name=$(basename "$f" .json)
        local type
        type=$(jq -r '.type // "unknown"' "$f")
        printf '  %-16s  %s\n' "$name" "$type"
      done
    }

    cmd_login() {
      local service="$1"
      local config_file="$SERVICES_DIR/$service.json"
      if [ ! -f "$config_file" ]; then
        echo "No config for '$service' at $config_file"
        echo "Create it first, then run 'auth-helper login $service'"
        exit 1
      fi

      local auth_type
      auth_type=$(jq -r '.type' "$config_file")

      ensure_dirs

      case "$auth_type" in
        basic)
          echo -n "Username (email): "
          read -r username
          echo -n "API token: "
          read -rs token
          echo
          local encoded
          encoded=$(printf '%s:%s' "$username" "$token" | base64)
          jq --arg token "$encoded" '.[$service] = $token' --arg service "$service" "$TOKENS_FILE" > "$TOKENS_FILE.tmp" &&
            mv "$TOKENS_FILE.tmp" "$TOKENS_FILE"
          chmod 600 "$TOKENS_FILE"
          echo "Logged in to $service"
          ;;

        bearer)
          echo -n "Bearer token: "
          read -rs token
          echo
          jq --arg token "$token" '.[$service] = $token' --arg service "$service" "$TOKENS_FILE" > "$TOKENS_FILE.tmp" &&
            mv "$TOKENS_FILE.tmp" "$TOKENS_FILE"
          chmod 600 "$TOKENS_FILE"
          echo "Token saved for $service"
          ;;

        oauth2)
          local client_id auth_url token_url scope port
          client_id=$(jq -r '.client_id' "$config_file")
          auth_url=$(jq -r '.auth_url' "$config_file")
          token_url=$(jq -r '.token_url' "$config_file")
          scope=$(jq -r '.scope // ""' "$config_file")
          port=''${AUTH_HELPER_PORT:-8899}

          local verifier challenge
          verifier=$(generate_code_verifier)
          challenge=$(generate_code_challenge "$verifier")

          local redirect_uri="http://localhost:$port/callback"
          local auth_request
          auth_request="$auth_url?response_type=code&client_id=$(urlencode "$client_id")&redirect_uri=$(urlencode "$redirect_uri")&code_challenge=$challenge&code_challenge_method=S256"
          [ -n "$scope" ] && auth_request="$auth_request&scope=$(urlencode "$scope")"

          echo "Opening browser for authorization..."
          open "$auth_request" 2>/dev/null || xdg-open "$auth_request" 2>/dev/null || \
            echo "Open this URL in your browser:"$'\n'"$auth_request"

          echo "Waiting for callback on port $port..."
          local auth_code response
          response=$(printf 'HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<html><body><h1>Authorized</h1><p>You may close this window.</p></body></html>' | nc -l "$port" 2>/dev/null || true)
          auth_code=$(echo "$response" | head -1 | sed -n 's/.*code=\([^& ]*\).*/\1/p')

          if [ -z "$auth_code" ]; then
            echo "Failed to capture authorization code"
            exit 1
          fi

          local token_response
          token_response=$(curl -s -X POST "$token_url" \
            -d "grant_type=authorization_code" \
            -d "client_id=$client_id" \
            -d "code=$auth_code" \
            -d "redirect_uri=$redirect_uri" \
            -d "code_verifier=$verifier")
          jq --argjson tokens "$token_response" '.[$service] = $tokens' --arg service "$service" "$TOKENS_FILE" > "$TOKENS_FILE.tmp" &&
            mv "$TOKENS_FILE.tmp" "$TOKENS_FILE"
          chmod 600 "$TOKENS_FILE"
          echo "Logged in to $service via OAuth2"
          ;;

        *)
          echo "Unsupported auth type: $auth_type"
          echo "Supported: basic, bearer, oauth2"
          exit 1
          ;;
      esac
    }

    cmd_token() {
      local service="$1"
      local config_file="$SERVICES_DIR/$service.json"
      if [ ! -f "$config_file" ]; then
        echo "No config for '$service'" >&2
        exit 1
      fi

      ensure_dirs

      local auth_type token_data
      auth_type=$(jq -r '.type' "$config_file")
      token_data=$(jq -r --arg s "$service" '.[$s] // ""' "$TOKENS_FILE")

      if [ -z "$token_data" ] || [ "$token_data" = "null" ]; then
        echo "Not logged in to $service. Run: auth-helper login $service" >&2
        exit 1
      fi

      case "$auth_type" in
        basic|bearer)
          printf '%s' "$token_data"
          ;;

        oauth2)
          local access_token expires_at refresh_token token_url client_id
          access_token=$(echo "$token_data" | jq -r '.access_token')
          expires_at=$(echo "$token_data" | jq -r '.expires_at // empty')
          refresh_token=$(echo "$token_data" | jq -r '.refresh_token // empty')

          if [ -n "$expires_at" ] && [ "$(date +%s)" -ge "$expires_at" ]; then
            if [ -n "$refresh_token" ]; then
              token_url=$(jq -r '.token_url' "$config_file")
              client_id=$(jq -r '.client_id' "$config_file")
              local new_tokens
              new_tokens=$(curl -s -X POST "$token_url" \
                -d "grant_type=refresh_token" \
                -d "client_id=$client_id" \
                -d "refresh_token=$refresh_token")
              jq --argjson tokens "$new_tokens" '.[$service] = $tokens' --arg service "$service" "$TOKENS_FILE" > "$TOKENS_FILE.tmp" &&
                mv "$TOKENS_FILE.tmp" "$TOKENS_FILE"
              chmod 600 "$TOKENS_FILE"
              access_token=$(echo "$new_tokens" | jq -r '.access_token')
            else
              echo "Token expired and no refresh token. Run: auth-helper login $service" >&2
              exit 1
            fi
          fi

          printf '%s' "$access_token"
          ;;

        *)
          echo "Unsupported auth type: $auth_type" >&2
          exit 1
          ;;
      esac
    }

    cmd_help() {
      echo "auth-helper — manage OAuth2 and API tokens for CLI tools"
      echo ""
      echo "Usage:"
      echo "  auth-helper list              List configured services"
      echo "  auth-helper login <service>   Authenticate and store credentials"
      echo "  auth-helper token <service>   Print current access token"
      echo "  auth-helper help              Show this help"
      echo ""
      echo "Service configs:  $SERVICES_DIR/<name>.json"
      echo "Token store:      $TOKENS_FILE"
      echo ""
      echo "Config format (basic):  { \"type\": \"basic\", \"base_url\": \"https://...\" }"
      echo "Config format (bearer): { \"type\": \"bearer\", \"base_url\": \"https://...\" }"
      echo "Config format (oauth2): { \"type\": \"oauth2\", \"client_id\": \"...\", \"auth_url\": \"...\", \"token_url\": \"...\" }"
    }

    case "''${1:-}" in
      list)    cmd_list ;;
      login)   cmd_login "''${2:-}" ;;
      token)   cmd_token "''${2:-}" ;;
      help|-h|--help)  cmd_help ;;
      *)
        echo "auth-helper: unknown command ''${1:-}"
        echo "Run 'auth-helper help' for usage."
        exit 1
        ;;
    esac
  '';
}
