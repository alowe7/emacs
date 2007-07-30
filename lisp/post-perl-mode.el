(put 'post-perl-mode 'rcsid 
 "$Id: post-perl-mode.el,v 1.27 2007-07-30 23:52:08 tombstone Exp $")
(require 'indicate)

(add-hook 'perl-mode-hook
	  '(lambda () 
	     (define-key perl-mode-map "" 'help-for-perl)
	     (define-key perl-mode-map (vector 'f1) 'pod)
	     (define-key perl-mode-map "" 'perlfunc)

	     (modify-syntax-entry ?$ "w" perl-mode-syntax-table)
	     (modify-syntax-entry ?_ "w" perl-mode-syntax-table)
	     (set-tabs 8)
	     ))

(require 'pod)

; do a perl debug

(defun perl-debug () (interactive)
  (setq shell-prompt-pattern "^\\([ ]*[a-zA-Z]*<[0-9]*>\\) *")
  )


; see reg.el
;(perl-command "queryval -v user \"software/Technology X/check/glom\"")

(setq perl-lib-cache nil)

(defun find-in-perl-lib-cache (a)
  (or (cadr (assoc a perl-lib-cache)) 
      (let ((f (expand-file-name (reg-query "machine" "software/perl" a))))
	(push (list a f) perl-lib-cache)
	f)))

; (find-in-perl-lib-cache "sitelib")
; (find-in-perl-lib-cache "lib")

(defun find-perl-module (s) 
  "given a module name like Date::Calc, find the .pm file"
  (interactive "sModule: ")

  (let ((fm (replace-in-string "::" "/" s)))

    (loop for a in (list "lib" "sitelib")
	  do
	  (let* ((d (find-in-perl-lib-cache a))
		 (f (concat d "/" fm ".pm")))

	    (if (file-exists-p f) (find-file f))))))

; (find-perl-module "Win32::ODBC")

(defun find-indicated-perl-module () 
  (interactive)
  (find-perl-module (indicated-word ":")))

(global-set-key "" 'find-indicated-perl-module)

(defun pod-perl-module (module) 
  (interactive "smodule: ")
  (let* ((l (ff (concat (replace-in-string "::" "/" module) ".pm")))
	 (m (and (> (length l) 0) (car l))))
    (if m
	(pod2text m)
      )
    )
  )

(defun list-perl-subs ()
  "collect all the subs in current buffer
"
  (list-things
   (format "^%s[ 	]+\\(.*\\)[ 	]"  "sub"))
  )

(defun list-things (pat)
"collect all the subs in current buffer
"
  (save-excursion
    (goto-char (point-min))
    (loop 
     while (re-search-forward pat nil t)
     collect (buffer-substring (match-beginning 1) (match-end 1))
     )
    )
  )

(defun perl-package-exports ()
  (insert "    @EXPORT      = qw(")
  (loop for x in (list-perl-subs) do (insert x " "))
  (insert ");
")
  )

;;; 
(defvar perl-helper-map nil)

(unless (fboundp 'ctl-C-ctl-P-prefix) 
    (define-prefix-command 'ctl-C-ctl-P-prefix))

(unless perl-helper-map
  (setq perl-helper-map (symbol-function 'ctl-C-ctl-P-prefix))
  (define-key perl-helper-map "m" 'pod-perl-module)
  (define-key perl-helper-map "" 'help-for-perl)
  (define-key perl-helper-map "" 'perlfunc)

  )

(global-set-key "" 'ctl-C-ctl-P-prefix)

(autoload 'perlfunc "perl-helpers" "help for perl functions" 'interactive)

