(setq user-full-name "Ian Luo" 
      user-mail-address "ianluo63@gmail.com")

(cond (IS-MAC
        (setq mac-command-modifier 'meta
              mac-option-modifier 'alt
              mac-right-option-modifier 'alt
              mac-pass-control-to-system nil)))

(setq kill-whole-line t)

(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 14)
      doom-variable-pitch-font (font-spec :family "Fira Code" :size 14))
