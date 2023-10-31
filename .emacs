;; assumes that option key is mapped to command,
;; command key mapped to control
(setq mac-command-modifier 'control)
(setq mac-option-modifier 'meta)
(ido-mode)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(auctex bind-key free-keys yaml-mode eglot rust-mode lsp-mode markdown-mode virtualenvwrapper exec-path-from-shell python-black zenburn-theme))
 '(warning-suppress-types '((auto-save))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq ring-bell-function 'ignore)

;; M-x package-install zenburn-theme
(load-theme 'zenburn t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(electric-pair-mode 1)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match
that used by the user's shell.

This is particularly useful under Mac OS X and macOS, where GUI
apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
			  "[ \t\n]*$" "" (shell-command-to-string
					  "$SHELL --login -c 'echo $PATH'"
						    ))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-PATH)

;; (shell-command-to-string "$SHELL -c 'echo $PATH'")
;; (getenv "SHELL")

;; (setenv "PATH" (concat "miniconda3/envs/"
;;                        (getenv "PATH")))
(setenv "PATH" (concat ".virtualenvs/"
                       (getenv "PATH")))
					;(add-to-list 'exec-path "miniconda3/envs")
(add-to-list 'exec-path ".virtualenvs")
(add-to-list 'exec-path "~/.local/bin")
(add-to-list 'exec-path "~/.cargo/bin")

(require 'virtualenvwrapper)
(venv-initialize-interactive-shells) ;; if you want interactive shell support
					;(setq venv-location "~/miniconda3/envs")
(setq venv-location "~/.virtualenvs")
(setq-default mode-line-format (cons '(:exec venv-current-name) mode-line-format))

  (setq python-shell-interpreter "ipython"
        python-shell-interpreter-args "-i --simple-prompt --InteractiveShell.display_page=True")

(add-hook 'python-mode-hook 'python-black-on-save-mode)
(add-hook 'python-mode-hook 'auto-revert-mode)

;; hide menu bar
;;(add-to-list 'default-frame-alist '(undecorated . t))

(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))

(setq lock-file-name-transforms `((".*" "~/tmp/emacs-lockfiles/" t)))
(setq auto-save-file-name-transforms `((".", "~/.emacs-saves" t)))

;; force splitting windows vertically
; this is always splitting vertically, whereas with python we need to replace opposing buffer
;(setq split-width-threshold 0)
;(setq split-height-threshold nil)


(setq lsp-pylsp-server-command "/Users/patrickoneil/.virtualenvs/bystro310-venv/bin/pylsp")

(require 'use-package)
(use-package lsp-mode
  :config
  (lsp-register-custom-settings
   '(("pyls.plugins.pyls_mypy.enabled" t t)
     ("pyls.plugins.pyls_mypy.live_mode" nil t)
     ("pyls.plugins.pyls_black.enabled" t t)
     ))
  :hook
  ((python-mode . lsp)))


(add-hook 'rust-mode-hook 'eglot-ensure)
(setq rust-format-on-save t)

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/gtd.org" "Tasks")
         ;;"* TODO %?\n  %i\n  %a"
	 "* TODO %?\n  %i\n"
	 )
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
					;"* %?\nEntered on %U\n  %i\n  %a"
	 "* %?\nEntered on %U\n  %i\n"
	 )))

(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "WAIT" "|" "DONE" "CANCELED")))

(bind-key "C-c c" 'org-capture)

;; (require 'flymake-mode)
;; (define-key flymake-mode-map (kbd "C-c C-n") 'flymake-goto-next-error)
;; (define-key flymake-mode-map (kbd "C-c C-p") 'flymake-goto-prev-error)

(set-exec-path-from-shell-PATH)

(setq TeX-auto-save t)
(setq TeX-parse-self t)

;; (setq lsp-modeline-code-actions-enable nil)
;; (setq lsp-modeline-diagnostics-enable nil)
(setq lsp-signature-render-documentation nil)

