(add-to-list 'load-path "~/emacs-config/")
(setq inhibit-splash-screen t)
(set-default-font "monospace 10")
(line-number-mode 1)
(column-number-mode 1)
(scroll-bar-mode -1)
(tool-bar-mode -1) 
(setq x-select-enable-clipboard t); why was this ever, ever disabled?
(ido-mode t)
(require 'inf-haskell)
(custom-set-variables
 '(haskell-program-name "ghci"))
(defun pdf-with-okular ()
(add-to-list 'TeX-output-view-style
(quote ("^pdf$" "." "okular %o %(outpage)"))))

(add-hook 'LaTeX-mode-hook 'pdf-with-okular t)
;;; bind RET to py-newline-and-indent
(add-hook 'python-mode-hook '(lambda () 
     (define-key python-mode-map "\C-m" 'newline-and-indent)))

(if (boundp 'python-remove-cwd-from-path)
    (setq python-remove-cwd-from-path nil)
  (progn 
    (defun python-reinstate-current-directory ()
      (python-send-string "sys.path[0:0] = ['']"))
    (add-hook 'inferior-python-mode-hook 'python-reinstate-current-directory)))
    
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

(require 'term)
(defun visit-ansi-term ()
  "If the current buffer is:
     1) a running ansi-term named *ansi-term*, rename it.
     2) a stopped ansi-term, kill it and create a new one.
     3) a non ansi-term, go to an already running ansi-term
        or start a new one while killing a defunt one"
  (interactive)
  (let ((is-term (string= "term-mode" major-mode))
        (is-running (term-check-proc (buffer-name)))
        (term-cmd "/bin/bash")
        (anon-term (get-buffer "*ansi-term*")))
    (if is-term
        (if is-running
            (if (string= "*ansi-term*" (buffer-name))
                (call-interactively 'rename-buffer)
              (if anon-term
                  (switch-to-buffer "*ansi-term*")
                (ansi-term term-cmd)))
          (kill-buffer (buffer-name))
          (ansi-term term-cmd))
      (if anon-term
          (if (term-check-proc "*ansi-term*")
              (switch-to-buffer "*ansi-term*")
            (kill-buffer "*ansi-term*")
            (ansi-term term-cmd))
        (ansi-term term-cmd)))))
(global-set-key (kbd "<f2>") 'visit-ansi-term)

(add-hook 'text-mode-hook 'turn-on-flyspell)
(global-set-key [C-backspace] 'flyspell-auto-correct-previous-word)

; define latex delimiters for org-mode
(fset 'org-latex-left-paren
      (lambda (&optional arg) 
	"Keyboard macro." 
	(interactive "p") 
	(kmacro-exec-ring-item 
	 (quote ("\\(" 0 "%d")) arg)))

(fset 'org-latex-right-paren
      (lambda (&optional arg) 
	"Keyboard macro." 
	(interactive "p") 
	(kmacro-exec-ring-item 
	 (quote ("\\)" 0 "%d")) arg)))

(add-hook 'org-mode-hook 
	  '(lambda () 
	     (define-key org-mode-map 
	       [(control \()] 
	     'org-latex-left-paren)))

(add-hook 'org-mode-hook 
	  '(lambda () 
	     (define-key org-mode-map 
	       [(control \))] 
	     'org-latex-right-paren)))
(add-hook 'org-mode-hook '(lambda () 
     (define-key org-mode-map "\C-)" 'org-latex-right-paren)))
