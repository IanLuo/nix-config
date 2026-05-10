{ pkgs, auth-helper, ... }:
pkgs.writeShellApplication {
  name = "chat-tools";
  runtimeInputs = with pkgs; [ curl jq auth-helper ];
  text = ''
    AUTH_HELPER="auth-helper"
    CONFIG_DIR="$HOME/.config/auth-helper/services"

    get_config() {
      jq -r "$2" "$CONFIG_DIR/$1.json"
    }

    get_token() {
      "$AUTH_HELPER" token "$1" 2>/dev/null
    }

    fetch_jira() {
      local issue_key token base_url
      issue_key="$1"
      token=$(get_token jira) || { echo "Error: not logged in to jira. Run: auth-helper login jira" >&2; exit 1; }
      base_url=$(get_config jira '.base_url')
      [ -z "$base_url" ] && { echo "Error: no base_url in jira config" >&2; exit 1; }

      curl -s -H "Authorization: Basic $token" \
        -H "Accept: application/json" \
        "$base_url/rest/api/3/issue/$issue_key" | \
        jq '{
          key: .key,
          summary: .fields.summary,
          status: .fields.status.name,
          assignee: .fields.assignee.displayName,
          description: (.fields.description.content // [] | if type == "array" then [.[] | .. | .text? // empty] | join(" ") else null end)[0:500],
          created: .fields.created,
          updated: .fields.updated
        }'
    }

    fetch_x() {
      local handle="$1"
      local token base_url
      token=$(get_token x) || { echo "Error: not logged in to x. Run: auth-helper login x" >&2; exit 1; }
      base_url=$(get_config x '.base_url')

      # Remove @ prefix if present
      handle="''${handle#@}"

      curl -s -H "Authorization: Bearer $token" \
        "$base_url/2/users/by/username/$handle?user.fields=description,public_metrics" | \
        jq '{
          name: .data.name,
          username: .data.username,
          description: .data.description,
          metrics: .data.public_metrics
        }'
    }

    fetch_x_tweets() {
      local handle="$1"
      local token base_url user_id
      token=$(get_token x) || { echo "Error: not logged in to x. Run: auth-helper login x" >&2; exit 1; }
      base_url=$(get_config x '.base_url')
      handle="''${handle#@}"

      user_id=$(curl -s -H "Authorization: Bearer $token" \
        "$base_url/2/users/by/username/$handle" | jq -r '.data.id')

      [ -z "$user_id" ] || [ "$user_id" = "null" ] && { echo "Error: could not find user $handle" >&2; exit 1; }

      curl -s -H "Authorization: Bearer $token" \
        "$base_url/2/users/$user_id/tweets?max_results=10&tweet.fields=created_at,public_metrics" | \
        jq '.data[:5] | .[] | {
          id: .id,
          text: .text,
          created: .created_at,
          retweets: .public_metrics.retweet_count,
          likes: .public_metrics.like_count
        }'
    }

    fetch_linear() {
      local issue_id="$1"
      local token
      token=$(get_token linear) || { echo "Error: not logged in to linear. Run: auth-helper login linear" >&2; exit 1; }

      local query='{"query": "query { issue(id: \"'"$issue_id"'\") { id title description state { name } assignee { name } createdAt updatedAt url } }"}'

      curl -s -H "Authorization: $token" \
        -H "Content-Type: application/json" \
        -d "$query" \
        "https://api.linear.app/graphql" | \
        jq '.data.issue'
    }

    fetch_custom() {
      local service="$1"
      local endpoint="$2"
      local token base_url auth_type
      token=$(get_token "$service") || { echo "Error: not logged in to $service" >&2; exit 1; }
      base_url=$(get_config "$service" '.base_url')
      auth_type=$(get_config "$service" '.type')

      case "$auth_type" in
        basic) curl -s -H "Authorization: Basic $token" "$base_url/$endpoint" | jq . ;;
        bearer) curl -s -H "Authorization: Bearer $token" "$base_url/$endpoint" | jq . ;;
        *) curl -s -H "Authorization: Bearer $token" "$base_url/$endpoint" | jq . ;;
      esac
    }

    cmd_help() {
      echo "chat-tools — fetch from authenticated sources for AI agent context"
      echo ""
      echo "Usage:"
      echo "  chat-tools jira <ISSUE-KEY>       Fetch Jira issue details"
      echo "  chat-tools x <@handle>             Fetch X user profile"
      echo "  chat-tools x-tweets <@handle>     Fetch recent tweets from user"
      echo "  chat-tools linear <ISSUE-ID>       Fetch Linear issue"
      echo "  chat-tools fetch <service> <path>  Generic: fetch from configured service"
      echo "  chat-tools list                    List configured services"
      echo "  chat-tools help                    Show this help"
      echo ""
      echo "Setup: Create configs in $CONFIG_DIR/<service>.json"
      echo "  Jira:  { \"type\": \"basic\",  \"base_url\": \"https://YOUR.atlassian.net\" }"
      echo "  X:     { \"type\": \"oauth2\", \"base_url\": \"https://api.x.com\", \"client_id\": \"...\", \"auth_url\": \"...\", \"token_url\": \"...\" }"
      echo "  Linear:{ \"type\": \"bearer\", \"base_url\": \"https://api.linear.app/graphql\" }"
      echo ""
      echo "Then: auth-helper login <service>"
    }

    cmd_list() {
      "$AUTH_HELPER" list
      echo ""
      echo "Supported chat-tools commands:"
      echo "  jira <ISSUE-KEY>"
      echo "  x <@handle>"
      echo "  x-tweets <@handle>"
      echo "  linear <ISSUE-ID>"
      echo "  fetch <service> <endpoint>"
    }

    case "''${1:-}" in
      jira)     fetch_jira "''${2:-}" ;;
      x)        fetch_x "''${2:-}" ;;
      x-tweets) fetch_x_tweets "''${2:-}" ;;
      linear)   fetch_linear "''${2:-}" ;;
      fetch)    fetch_custom "''${2:-}" "''${3:-}" ;;
      list)     cmd_list ;;
      help|-h|--help) cmd_help ;;
      *)
        echo "chat-tools: unknown command ''${1:-}"
        echo "Run 'chat-tools help' for usage."
        exit 1
        ;;
    esac
  '';
}
