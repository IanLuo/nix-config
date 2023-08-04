{ pkgs, ... }: with pkgs;
let
  myConfigs = writeText "default.el" ''
    ;; Map Option Key to Meta Key
    (setq mac-option-modifier 'meta)
    (setq mac-right-option-modifier 'meta)

    ;; Set backup directory
    (setq backup-directory-alist `(("." . "~/.emacs.d/backups")))

    ;; Set auto-save directory
    (setq auto-save-file-name-transforms `((".*" "~/.emacs.d/auto-save-list/" t)))
  
    (require 'package)
    (package-initialize 'noactivate)
    (eval-when-compile
      (require 'use-package))

    ;; load some packages

    (use-package company
      :bind ("<C-tab>" . company-complete)
      :diminish company-mode
      :commands (company-mode global-company-mode)
      :defer 1
      :config
      (global-company-mode))

    (use-package flycheck
      :defer 2
      :config (global-flycheck-mode))

    (use-package magit
      :defer
      :if (executable-find "git")
      :bind (("C-x g" . magit-status)
      	     ("C-x G" . magit-dispatch-popup))
      :init
      (setq magit-completing-read-function 'ivy-completing-read))

    (use-package ivy
      :defer 1
      :bind (("C-c C-r" . ivy-resume)
      	     ("C-x C-b" . ivy-switch-buffer)
	     :map ivy-minibuffer-map
	     ("C-j" . ivy-call))
      :diminish ivy-mode
      :commands ivy-mode
      :config
      (ivy-mode 1))

    '';
  myEmacs = emacs.pkgs.withPackages (epkgs: (with epkgs.melpaStablePackages; [
    (runCommand "default.el" {} ''
      mkdir -p $out/share/emacs/site-lisp
      cp ${myConfigs} $out/share/emacs/site-lisp/default.el
    '')
    company
    ivy
    flycheck
    use-package
    magit
    evil
  ]));
in
myEmacs