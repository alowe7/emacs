(defconst rcs-id "$Id: post-perl-mode.el,v 1.3 2000-07-30 21:07:47 andy Exp $")
(require 'indicate)

(add-hook 'perl-mode-hook
	  '(lambda () 
	     (define-key perl-mode-map "" 'help-for-perl)
	     (modify-syntax-entry ?$ "w" perl-mode-syntax-table)
	     (modify-syntax-entry ?_ "w" perl-mode-syntax-table)
	     ))

; see reg.el

(defun pod2text (f &optional buffer-name)
  (interactive "ffile: ")
  (let* ((b (zap-buffer (or buffer-name "*pod*"))))
    (insert 
     (perl-command "pod2text" f))

; if window is visible in another frame, then raise it
    (if (and (not (get-buffer-window b))  
	     (get-buffer-window b t))
	(raise-frame
	 (select-frame
	  (window-frame 
	   (get-buffer-window b t)))))

    (pop-to-buffer b)
    (view-mode)
    (not-modified)
    (setq buffer-read-only t)
    (beginning-of-buffer)
    )
  )

(defun pod ()
	"if looking at a perl script containing pod, format it as text."
	(interactive)

	(pod2text (buffer-file-name) (concat (file-name-sans-extension (buffer-name)) " *pod*"))
	)


(define-key  perl-mode-map (vector 'f1) 'pod)

; do a perl debug

(defvar saved-comint-prompt-regexp nil)

(defun pd () (interactive)
  (push comint-prompt-regexp saved-comint-prompt-regexp) 
  (setq comint-prompt-regexp "^\\([ ]*[a-zA-Z]*<[0-9]*>\\) *")
  )

;(pod2text "/usr/local/lib/perl/site/lib/Netscape/History.pm")
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


; defvar
(addloadpath "$HOME/emacs/site-lisp/perl")

(autoload 'perlfunc "perl-helpers" "help for perl functions" 'interactive)

(define-key perl-mode-map "" 'perlfunc)
