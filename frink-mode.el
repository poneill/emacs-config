;; Frink major mode for emacs
;; Alan Eliasen, eliasen@mindspring.com
;;
;; Frink can be found at:  http://futureboy.homeip.net/frinkdocs/
;;
;; Suggestions and improvements are very welcome.  I'm a horrid emacs LISP
;; programmer.
;;
;; Reference for this file was taken from
;; http://two-wugs.net/emacs/mode-tutorial.html
;;
;; Installation instructions:
;;
;; 1. Put this file somewhere in your emacs load path OR add the following
;;    to your .emacs file (modifying the path appropriately) :
;;
;;    (add-to-list 'load-path "/home/eliasen/prog/frink/tools")
;;
;; 2. Add the following to your .emacs file to make this autoload:
;;
;;    (autoload 'frink-mode "frink-mode")
;;    (setq auto-mode-alist       
;;       (cons '("\\.frink\\'" . frink-mode) auto-mode-alist))
;;
;; 3. (Optional) Customize Frink mode with your own hooks.  Below is a sample
;;    which automatically untabifies when you save:
;;
;;    (defun my-frink-mode-hook ()
;;      (add-hook 'local-write-file-hooks 'auto-untabify-on-save))
;;
;;    (add-hook 'frink-mode-hook 'my-frink-mode-hook)
;;


; Define a hook to allow users to run their own code when this mode is run.
(defvar frink-mode-hook nil)

; Define a keymap
(defvar frink-mode-map nil
  "Keymap for Frink major mode"
)

; Assign a default keymap, if the user hasn't already defined one.
(if frink-mode-map nil
  (setq frink-mode-map (make-sparse-keymap))
  (define-key frink-mode-map "\C-m" 'newline-and-indent)
  (define-key frink-mode-map "{" 'frink-electric-brace)
  (define-key frink-mode-map "}" 'frink-electric-brace)
  (define-key frink-mode-map "\C-c\C-c" 'frink-run-buffer)  
  (define-key frink-mode-map "\C-c\C-l" 'frink-run-buffer-then-interactive)  
  (define-key frink-mode-map "\C-c\C-z" 'run-frink)  
)

(defun frink-electric-brace (arg)
  "Make the curly brace indent itself properly."
  (interactive "P")
  (self-insert-command (prefix-numeric-value arg))
  (unless
      (save-excursion
	(beginning-of-line)
        (or
	  (looking-at "\%[rs]/") ;Don't do this in a regular expression
	  (looking-at "{\s*|[^}]") ;Don't do this in an open procedure block
	  (looking-at "\"[^\"]*$")) ;Don't do this in a open string
       )
    (frink-indent-line)
    (forward-char 1)
  )
)


; Set a mapping for Frink files
(setq auto-mode-alist
	  (append
	   '(("\\.frink\\'" . frink-mode))
	   auto-mode-alist)
)

; Set up minimal keywords
(defconst frink-font-lock-keywords-1
  (list
   ; Multi-line-strings
;   '("\\(\"\"\".*\"\"\"\\)" . font-lock-string-face)
   ; Strings
;   '("\\(\"[^\"]*\"\\)" . font-lock-string-face)
   ; Keywords
   ; In the below, the \\< and \\> only match at word or file boundaries.
   '("\\<\\(true\\|false\\|TRUE\\|FALSE\\|and\\|AND\\|or\\|OR\\|not\\|NOT\\|nand\\|NAND\\|nor\\|NOR\\|xor\\|XOR\\|implies\\|IMPLIES\\|if\\|\\then\\|else\\|for\\|multifor\\|to\\|step\\|next\\|use\\|while\\|do\\|var\\|class\\|interface\\|try\\|finally\\|transformations\\|implements\\|return\\|new\\|undef\\eval\\|noEval\\|mod\\|div\\|conforms\\|cube\\|square\\|cubed\\|squared\\\|\\([PC]\\(EQ\\|NE\\|LT\\|LE\\|GT\\|GE\\)\\)\\)\\>" . font-lock-keyword-face)
   ; Date Literals
   '("\\(#[^#]*#?\\)" . font-lock-constant-face)
   ; Variables
   ;   '("\\('\\w*'\\)" . font-lock-variable-name-face)
   )
  "Minimal highlighting expressions for Frink mode"
)

; Might add more later
(defvar frink-font-lock-keywords frink-font-lock-keywords-1
  "Default highlighting expressions for Frink mode"
)


;; Function to control indenting.
(defun frink-indent-line ()
  "Indent current line as Frink code"
  (interactive)

  ;; Set the point to beginning of line.
  (beginning-of-line)

  ;; The first indentation-related thing we do is to check to see if this is
  ;; the first line in the buffer, using the function bobp. If it is, we set
  ;; the indentation level to 0, using indent-line-to. indent-line-to indents
  ;; the current line to the given column. Please note that if this condition
  ;; is true, then the rest of the indentation code is not considered.
  (if (bobp)
      (indent-line-to 0)

  ;; Now we declare two variables. We will store the value of our intended
  ;; indentation level for this line in cur-indent. Then, when all of the
  ;; indentation options have been considered (rules 2-5), we will finally
  ;; make the indentation.
    (let ((not-indented t) (lines-back 0) cur-indent)

  ;; If we see that we are at the end of a block, we then set the indentation
  ;; level. We do this by going to the previous line (using the forward-line
  ;; function), and then use the current-indentation function to see how that
  ;; line is indented. Then we set cur-indent with the value of the previous
  ;; line's indentation, minus the frink-indent-width.
      (if (looking-at "^[ \t]*}") ; Check for closing brace
	  (progn
	    (save-excursion
	      (forward-line -1)
              (setq lines-back (+ lines-back 1))
	      (if (looking-at "^[ \t]*{") ; If now looking at opening block
		(setq cur-indent (current-indentation)) ;; duplicate indent
		(setq cur-indent (- (current-indentation) frink-indent-width)))
            )

  ;; Safety check to make sure we don't indent negative.
	    (if (< cur-indent 0)
		(setq cur-indent 0)))

	(save-excursion 
	  (if (looking-at "^[ \t]*{") ; Opening block
	      (progn
		(forward-line -1)
		(setq lines-back (+ lines-back 1))
		(setq cur-indent (current-indentation))
		(setq not-indented nil))

	    (while not-indented
	      (forward-line -1)
              (setq lines-back (+ lines-back 1))
	      (if (looking-at "^[ \t]*}") ; Closing block
		  (progn
		    (setq cur-indent (current-indentation))
		    (setq not-indented nil))
		
		(if (looking-at "^[ \t]*{") ; Opening block
		    (progn
		      (setq cur-indent (+ (current-indentation) frink-indent-width))
		      (setq not-indented nil))
		      
		(if (looking-at "^[ \t]*\\(if\\|else\\|for\\|multifor\\|while\\|try\\|finally\\)\\>")
		    (progn
		      (setq cur-indent (current-indentation))
		      (forward-line 1)
		      (setq lines-back (- lines-back 1))
		      (if (looking-at "^[ \t]*{") ; Has block
			  (setq not-indented nil)
			(if (equal lines-back 0) ; No block
			    (progn
			      (setq cur-indent (+ cur-indent frink-indent-width))
			      (setq not-indented nil))
			  (setq not-indented nil)))
		      )
		  (if (bobp)
		      (setq not-indented nil)))))))))

  ;; Finally, we execute the actual indentation, if we have actually
  ;; identified an indentation case. We have (most likely) already stored the
  ;; value of the indentation in cur-value. If cur-indent is empty, then we
  ;; always indent to column 0.

      (if cur-indent
          (indent-line-to cur-indent)
        (indent-line-to 0)))))

;; We will use the make-syntax-table function to create an empty syntax
;; table. This function creates a syntax table that is a good start for most
;; modes, as it either inherits or copies entries from the standard syntax
;; table.
;;
;; You'll definitely need an elisp manual for this:
;; http://www.delorie.com/gnu/docs/elisp-manual-21/elisp_582.html
;;
;; and the tutorial at:
;;   http://www.emacswiki.org/emacs/ModeTutorial
;;
;; Also note that XEmacs 21 has different definitions for
;; modify-syntax-entry
(defvar frink-mode-syntax-table
  (let ((frink-mode-syntax-table (make-syntax-table)))

   ;; Comment handler.
   ;; Gnu Emacs and XEmacs have different modify-syntax-entry rules.
   (if (string-match "XEmacs\\|Lucid" emacs-version)
      ;; Xemacs-style code.
      ;; See
      ;; http://www.xemacs.org/Documentation/21.5/html/lispref_46.html
      ;; Xemacs currently doesn't handle nested multi-line comments.
      (progn 				
        (modify-syntax-entry ?\/ ". 1456" frink-mode-syntax-table)

         ;; Comment character * for multi-line comments
        (modify-syntax-entry ?\* ". 23" frink-mode-syntax-table)

        ;; Comment ender for single-line comments.
        (modify-syntax-entry ?\n "> b" frink-mode-syntax-table)
        (modify-syntax-entry ?\r "> b" frink-mode-syntax-table)
      )
     
     ;; GNU emacs style syntax table.
     ;; This is bloody cryptic, but here's what it means.
     ;;  The slash is the character we're modifying.
     ;;  The . means that it's punctuation (you can't make it a comment starter
     ;;    or everything following even a single slash becomes a comment.)
     ;;  The space means "matching character slot unused" (whatever *that* means)
     ;;  The 1 means it's the 1st char of a 2-character comment start sequence
     ;;  The 2 means it's the 2nd char of a 2-character comment start sequence
     ;;  The 4 means it's the last char of a matched block
     ;;  The b means it's a "b-style" comment
      (progn
        (modify-syntax-entry ?\/ ". 124b" frink-mode-syntax-table)

         ;; Comment character * for multi-line comments
        (modify-syntax-entry ?\* ". 23n" frink-mode-syntax-table)

        ;; Comment ender for single-line comments.
        (modify-syntax-entry ?\n "> b" frink-mode-syntax-table)
        (modify-syntax-entry ?\r "> b" frink-mode-syntax-table)
      )
   )

   frink-mode-syntax-table)
  "Syntax table for frink-mode"
)


; Mode to set up Frink editing.
(defun frink-mode ()
  "Major mode for editing Frink program files"
  ; Here we define our entry function, give it a documentation string, make it
  ; interactive, and call our syntax table creation function.
  (interactive)
  (kill-all-local-variables)

  (set-syntax-table frink-mode-syntax-table)

  ; Now we are specifying the font-lock (syntax highlighting) default
  ; keywords. Note that if the user has specified her own level of keyword
  ; highlighting by redefinine frink-font-lock-keywords, then that will be used
  ; instead of the default.
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults
		'(frink-font-lock-keywords nil nil nil nil))

   ; Here we register our line indentation function with Emacs. Now Emacs will
   ; call our function every time line indentation is required (like when the
   ; user calls indent-region).
  (make-local-variable 'indent-line-function)
  (setq indent-line-function 'frink-indent-line)

   ; Set indentation defaults.
  (make-local-variable 'frink-indent-width)
  (setq frink-indent-width 3)

  ; Allow the normal compile command (usually C-x c) to run Frink programs
  (make-local-variable 'compile-command)
  (setq compile-command (format "frink %s"
			 (file-name-nondirectory buffer-file-name)))

   ; Comment modes used by M-;
;;  (make-local-variable 'comment-start)
;;  (setq comment-start "// ")
;;  (make-local-variable 'comment-start-skip)
;;  (setq comment-start-skip "// *")

  (use-local-map frink-mode-map)


   ; The last steps in the entry function are to set the major-mode variable
   ; with the value of our mode, to set the mode-name variable (which
   ; determines what name will appear in the status line and buffers menu, for
   ; example), and to finally call run-hooks so that the user's own mode hooks
   ; will be called.
  (setq major-mode 'frink-mode)
  (setq mode-name "Frink")

   ; Set up menu bar
  (easy-menu-define frink-menu frink-mode-map "Frink Menu"
    '("Frink"
      ["Run"   frink-run-buffer t]
      ["Run buffer interactive"   frink-run-buffer-then-interactive t]
      ["Interactive mode"   run-frink t]
     ))
  (easy-menu-add frink-menu frink-mode-map)

  (run-hooks 'frink-mode-hook)
)

; Start an interactive Frink buffer.  This assumes you have a script
; called "frink" that runs Frink in command-line mode.  Sample scripts are
; available at:
;  http://futureboy.us/frinkdocs/#RunningFrink
;
(defun run-frink ()
  "Start an interactive Frink buffer."
  (interactive)
  (comint-run "frink"))

; Runs the program in the current buffer, making a new window for its output.
; This will prompt to save any unsaved files before running.
(defun frink-run-buffer (&optional preargs)
  "Runs the Frink program that's in the current buffer."
  (interactive)
  (save-some-buffers)
  (let ( (origfile (buffer-file-name))
         (origbuf (buffer-name)) )
     (let ((outbuf (get-buffer-create (concat "*Frink Output--" origbuf "*"))))
       (switch-to-buffer-other-window outbuf)
       (comint-mode)
       (erase-buffer)
       (comint-exec outbuf (concat "\"frink " origfile "\"") "frink" nil (if preargs (list preargs origfile) (list origfile)))
     )
;;     (other-window -1)
  )
)

; Runs the current buffer and then goes into interactive mode.
(defun frink-run-buffer-then-interactive ()
   "Runs the current buffer in a Frink interpreter and then puts that interpreter into interactive mode."
   (interactive)
   (frink-run-buffer "-k")
;;   (other-window +1)
)

(provide 'frink-mode)
