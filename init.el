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
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacs.d/autosaves/\\1" t))))
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
 '(dired-listing-switches "-alh")
 '(haskell-program-name "ghci")
 '(weblogger-config-alist (quote (("default" "http://bloginavat.wordpress.com/xmlrpc.php" "synapseandsyntax" "" "4063925")))))

(setq Tex-PDF-mode t)
(add-hook 'doc-view-mode-hook 'auto-revert-mode)

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
(defun haskell-mode-lint-hook ()
 (local-set-key "\C-cl" 'hs-lint))

(add-hook 'haskell-mode-hook 'haskell-mode-lint-hook)

(global-set-key (kbd "C-x a r") 'align-regexp)
;; automatically add trace boilerplate when executed with point at
;; beginning of first line of function definition.  Note: does not
;; work with functions written in point-free style (how could it?).
;; All function arguments must be specified.
(fset 'haskell-trace-function
   [?\C-  ?\C-s ?= ?\M-w ?\C-a return ?\C-p ?\C-y backspace backspace ?\C-a ?\C-k ?\C-y ?  ?| ?  ?t ?r ?a ?c ?e ?  ?\( ?\C-y ?\C-x ?\C-x ?\" ?\M-f ?\" ?\C-  ?\C-e ?\M-% ?  return ?+ ?+ ?  ?\" ?  ?\" ?\S-  ?+ ?\S-  ?+ backspace backspace ?+ ?  ?s ?h ?o ?w ?  return ?! ?\M-f ?\) ?  ?F ?a ?l ?s ?e ?  ?= ?  ?u ?n ?d ?e ?f ?i ?n ?e ?d])
(define-key haskell-mode-map (kbd "C-c t") 'haskell-trace-function)

(load-library "haskell-site-file")
;; Literate Haskell [requires MMM] courtesy David Bremner
(require 'mmm-auto)
(require 'mmm-haskell)
(setq mmm-global-mode 'maybe)
(add-to-list 'mmm-mode-ext-classes-alist
   '(latex-mode "\\.lhs$" haskell))
(setenv "PATH" (concat (getenv "PATH") 
		      ":~/.cabal/bin"))
;; allow ghci to read expressions of greater than 253 chars in length!
(add-hook 'haskell-mode-hook
       '(lambda ()
          (setq process-connection-type nil))) 
(add-to-list 'auto-mode-alist '("\\.lhs\\'" . latex-mode))
(eval-after-load "tex"
'(progn
    (add-to-list 'LaTeX-command-style '("lhs" "lhslatex"))
    (add-to-list 'TeX-file-extensions "lhs")))


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

(autoload 'frink-mode "frink-mode")
(setq auto-mode-alist       
      (cons '("\\.frink\\'" . frink-mode) auto-mode-alist))

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

;Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.


;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/autosaves/" t)

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(mmm-default-submode-face ((t (:background "gray25")))))
(require 'weblogger)
(require 'xml-rpc)

(fset 'haskell-copy-list-to-r
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([201326624 134217847 24 111 25 backspace 41 1 4 99 40 1 95 1] 0 "%d")) arg)))

(defun my-haskell-mode-hook ()
 (local-set-key "\C-c<" 'haskell-copy-list-to-r))

(add-hook 
 'haskell-mode-hook 
 '(lambda () (define-key haskell-mode-map "\C-c<" 'haskell-copy-list-to-r)))

(require 'geiser-install)

