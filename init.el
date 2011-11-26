(setq inhibit-splash-screen t)
(line-number-mode 1)
(column-number-mode 1)

(tool-bar-mode -1) ; no tool bar with icons

(ido-mode t)
(defun pdf-with-okular ()
(add-to-list 'TeX-output-view-style
(quote ("^pdf$" "." "okular %o %(outpage)"))))

(add-hook 'LaTeX-mode-hook 'pdf-with-okular t)

;;; bind RET to py-newline-and-indent
(add-hook 'python-mode-hook '(lambda () 
     (define-key python-mode-map "\C-m" 'newline-and-indent)))

(add-hook 'python-mode-hook
     (lambda ()
      (define-key python-mode-map "\"" 'electric-pair)
      (define-key python-mode-map "\'" 'electric-pair)
      (define-key python-mode-map "(" 'electric-pair)
      (define-key python-mode-map "[" 'electric-pair)
      (define-key python-mode-map "{" 'electric-pair)
     ))

(add-hook 'ess-mode-hook
     (lambda ()
      (define-key ess-mode-map "\"" 'electric-pair)
      (define-key ess-mode-map "\'" 'electric-pair)
      (define-key ess-mode-map "(" 'electric-pair)
      (define-key ess-mode-map "[" 'electric-pair)
      (define-key ess-mode-map "{" 'electric-pair)
     ))

(add-hook 'slime-mode-hook
     (lambda ()
      (define-key slime-mode-map "\"" 'electric-pair)
      (define-key slime-mode-map "(" 'electric-pair)
      (define-key slime-mode-map "[" 'electric-pair)
      (define-key slime-mode-map "{" 'electric-pair)
     ))

(add-hook 'lisp-mode-hook
     (lambda ()
      (define-key lisp-mode-map "\"" 'electric-pair)
      (define-key lisp-mode-map "(" 'electric-pair)
      (define-key lisp-mode-map "[" 'electric-pair)
      (define-key lisp-mode-map "{" 'electric-pair)
     ))

(fset 'insert-docstring
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([34 34 34 return return 16 tab] 0 "%d")) arg)))




(defun electric-pair ()
  "Insert character pair without sournding spaces"
  (interactive)
  (let (parens-require-spaces)
    (insert-pair)))

;;;python docstrings
(fset 'insert-docstring
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([34 34 34 return return 16 tab] 0 "%d")) arg)))
;;;latex dollars
(fset 'insert-dollar-signs
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("$$" 0 "%d")) arg)))
(global-set-key (kbd "C-$") 'insert-dollar-signs)
(show-paren-mode t)
(setq ess-eval-visibly-p nil)

(setq dna-do-setup-on-load t)
(load "~/emacs-config/dna-mode")
(put 'downcase-region 'disabled nil)
(load "~/emacs-config/zenburn")
(require 'zenburn)
(color-theme-zenburn)

(load "~/emacs-config/hs-lint")
(require 'hs-lint)
(defun my-haskell-mode-hook ()
 (local-set-key "\C-cl" 'hs-lint))

(add-hook 'haskell-mode-hook 'my-haskell-mode-hook)

(global-set-key (kbd "C-x a r") 'align-regexp)