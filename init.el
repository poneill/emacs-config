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
 '(haskell-program-name "ghci")
 '(jabber-auto-reconnect t)
 '(jabber-avatar-verbose nil)
 '(jabber-chat-buffer-format "*-jabber-%n-*")
 '(jabber-history-enabled t)
 '(jabber-mode-line-compact nil)
 '(jabber-mode-line-mode nil)
 '(jabber-roster-buffer "*-jabber-*")
 '(jabber-roster-line-format " %c %-25n %u %-8s (%r)")
 '(jabber-show-offline-contacts nil)
 '(jabber-vcard-avatars-retrieve nil)
 '(mediawiki-debug t)
 '(mediawiki-site-default "erill-lab")
 ;;'(python-python-command "python")
 '(scroll-step 1)
 '(weblogger-config-alist (quote (("erill-lab" "http://compbio.umbc.edu/xmlrpc.php" "pon2" "" "1") ("default" "http://bloginavat.wordpress.com/xmlrpc.php" "synapseandsyntax" "" "4063925")))))

(setq Tex-PDF-mode t)
(add-hook 'doc-view-mode-hook 'auto-revert-mode)

;;; bind RET to py-newline-and-indent
 (add-hook 'python-mode-hook '(lambda () 
      (define-key python-mode-map "\C-m" 'newline-and-indent)))

;; (if (boundp 'python-remove-cwd-from-path)
;;     (setq python-remove-cwd-from-path nil)
  ;; (progn 
  ;;   (defun python-reinstate-current-directory ()
  ;;     (python-send-string "sys.path[0:0] = ['']"))
  ;;   (add-hook 'inferior-python-mode-hook 'python-reinstate-current-directory)))
    
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

(add-hook 'latex-mode-hook;lowercase!
     (lambda ()
      (define-key LaTeX-mode-map "\"" 'electric-pair);mixed-case! FFFFUUUUUUU
      (define-key LaTeX-mode-map "\'" 'electric-pair)
      (define-key LaTeX-mode-map "(" 'electric-pair)
      (define-key LaTeX-mode-map "[" 'electric-pair)
      (define-key LaTeX-mode-map "{" 'electric-pair)
     ))

(add-hook 'c-mode-hook
     (lambda ()
      (define-key c-mode-map "\"" 'electric-pair)
      (define-key c-mode-map "\'" 'electric-pair)
      (define-key c-mode-map "(" 'electric-pair)
      (define-key c-mode-map "[" 'electric-pair)
      (define-key c-mode-map "{" 'electric-pair)
     ))

(fset 'insert-docstring
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([34 34 34 return return 16 tab] 0 "%d")) arg)))


(electric-pair-mode)
(add-hook 'LaTeX-mode-hook
          '(lambda ()
            (define-key LaTeX-mode-map (kbd "$") 'self-insert-command)))

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

(defun ltx-environment (start end)
  "Insert LaTeX environment."
;  (interactive "r\nsEnvironment type: ")
  (save-excursion
    (if (region-active-p)
	(progn
	  (goto-char end)
	  (insert "$")
	  (goto-char start)
	  (insert "$"))
      (insert "$")
      (insert "$"))))

(defun foo (start)
  "Insert LaTeX environment."
  (interactive)
    (if (region-active-p) 
	(progn
	  (goto-char start)
	  (insert "$"))
      (insert "$$")))


(setq dna-do-setup-on-load t)
(load "~/emacs-config/dna-mode")
(put 'downcase-region 'disabled nil)
(load "~/emacs-config/zenburn")
;(require 'zenburn)
;(color-theme-zenburn)

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

;(load-library "haskell-site-file")
;;; Literate Haskell [requires MMM] courtesy David Bremner
;(require 'mmm-auto)
;(require 'mmm-haskell)
;(setq mmm-global-mode 'maybe)
;(add-to-list 'mmm-mode-ext-classes-alist
;   '(latex-mode "\\.lhs$" haskell))
;(setenv "PATH" (concat (getenv "PATH") 
;		      ":~/.cabal/bin"))
;;; allow ghci to read expressions of greater than 253 chars in length!
;(add-hook 'haskell-mode-hook
;       '(lambda ()
;          (setq process-connection-type nil))) 
;(add-to-list 'auto-mode-alist '("\\.lhs\\'" . latex-mode))
;(eval-after-load "tex"
;'(progn
;    (add-to-list 'LaTeX-command-style '("lhs" "lhslatex"))
;    (add-to-list 'TeX-file-extensions "lhs")))


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

(add-hook 'LaTeX-mode-hook
          #'(lambda ()
              (modify-syntax-entry ?$ "\"")))
(put 'narrow-to-region 'disabled nil)

(load-file "~/emacs-config/geiser/geiser.el")
(load-file "~/emacs-config/geiser/geiser-install.el.in")
(require 'geiser-install)

(load-file "~/emacs-config/autopair.el")
(require 'autopair)

(load-file "~/emacs-config/autopair-latex.el")
(require 'autopair-latex)

(add-to-list 'load-path "~/emacs-config/geiser")


(put 'narrow-to-region 'disabled nil)
;;scope of following macro should be narrowed to python mode
;; (fset 'execute-line
;;    [?\M-m ?\C-  ?\C-e ?\M-w ?\C-x ?o ?\C-y return ?\C-x ?o ?\C-n])
;; (global-set-key (kbd "C-c <return>") 'execute-line)

;; (defun my-run-python (&optional new)
;;   (interactive "P")
;;   (if new
;;    (run-python nil nil new)
;;    (pop-to-buffer (process-buffer (python-proc)) t)))

;; (add-hook
;;  'python-mode-hook
;;  '(lambda () (define-key python-mode-map (kbd "C-c C-z") 'my-run-python)))

(fset 'python-convert-lambda-to-def
   [?\C-a ?d ?e ?f ?  ?\C-s ?l ?a ?m ?b ?d ?a ?\C-m M-backspace backspace backspace backspace ?\C-d ?\( ?\C-d ?\C-s ?: ?\C-m backspace ?\) ?: return ?r ?e ?t ?u ?r ?n ?  ?\C-e])

(require 'clojure-mode)
(add-hook 'nrepl-interaction-mode-hook
  'nrepl-turn-on-eldoc-mode)
(setq nrepl-hide-special-buffers t)
(defun my-nrepl-jack-in ()
  (interactive)
  (dolist (buffer (buffer-list))
    (when (string-prefix-p "*nrepl" (buffer-name buffer))
      (kill-buffer buffer)))
  (nrepl-jack-in nil))

(require 'mediawiki)
(require 'xpp)
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(autoload 'xpp-mode "xpp" "Enter XPP mode." t)
(setq auto-mode-alist (cons '("\\.ode\\'" . xpp-mode) auto-mode-alist))
(require 'markdown-mode)

;; (add-to-list 'load-path "~/ESS/lisp")
;; (load "~/ESS/lisp/ess-site")
(setq inferior-julia-program-name "/usr/bin/julia-basic")

;;;python-mode.el stuff
;;(require 'python-mode)
;;(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;;(add-to-list 'interpreter-mode-alist '("python" . python-mode))
;;; end python-mode.el stuff

;;; ipython stuff
;;(require 'ipython)

(setq
 python-shell-interpreter "ipython"
 python-shell-interpreter-args ""
 python-shell-prompt-regexp "In \\[[0-9]+\\]: "
 python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
 python-shell-completion-setup-code
   "from IPython.core.completerlib import module_completion"
 python-shell-completion-module-string-code
   "';'.join(module_completion('''%s'''))\n"
 python-shell-completion-string-code
   "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")
;;; end ipython stuff
(require 'ein)

(require 'package)
(add-to-list 'package-archives 
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))

(add-to-list 'package-archives 
	     '("melpa" . 
	       "http://melpa.milkbox.net/packages/"))
(package-initialize)

;;; gchat in emacs: solving a problem you never knew you had!
(setq jabber-account-list
    '(("pon2@umbc.edu" 
       (:network-server . "talk.google.com")
       (:connection-type . ssl))))

(require 'org-beamer)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(jabber-auto-reconnect t)
 '(jabber-avatar-verbose nil)
 '(jabber-vcard-avatars-retrieve nil)
 '(jabber-chat-buffer-format "*-jabber-%n-*")
 '(jabber-history-enabled t)
 '(jabber-mode-line-mode t)
 '(jabber-roster-buffer "*-jabber-*")
 '(jabber-roster-line-format " %c %-25n %u %-8s (%r)")
 '(jabber-show-offline-contacts nil))

(setq LaTeX-command-style '(("" "%(PDF)%(latex) -file-line-error %S%(PDFout)"))) ; give informative pdflatex error messages

(require 'pomodoro) 
(pomodoro-add-to-mode-line)


;; define chip-seq macros!
(fset 'chip-seq (lambda (&optional arg) "Keyboard macro." (interactive "p") (insert "ChIP-Seq")))
(fset 'chip-exo (lambda (&optional arg) "Keyboard macro." (interactive "p") (insert "ChIP-Exo")))
(fset 'plt (lambda (&optional arg) "Keyboard macro." (interactive "p") (insert "from matplotlib import pyplot as plt")))


(add-hook 'latex-mode-hook '(lambda () 
     (define-key latex-mode-map "\C-c s" 'chip-seq)))
