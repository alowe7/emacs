(put 'post-perl-mode 'rcsid 
 "$Id: post-perl-mode.el,v 1.13 2002-03-05 06:10:13 cvs Exp $")
(require 'indicate)

(add-hook 'perl-mode-hook
	  '(lambda () 
	     (define-key perl-mode-map "" 'help-for-perl)
	     (define-key  perl-mode-map (vector 'f1) 'pod)
	     (define-key perl-mode-map "" 'perlfunc)

	     (modify-syntax-entry ?$ "w" perl-mode-syntax-table)
	     (modify-syntax-entry ?_ "w" perl-mode-syntax-table)
	     ))

; see reg.el

(defvar pod2text (find-script "pod2text"))

(defun pod2text (f &optional buffer)
  (interactive "ffile: ")
  (let* ((b (cond ((buffer-live-p buffer) buffer)
		  (t (zap-buffer (or buffer "*pod*"))))))
    (insert 
     (perl-command pod2text f))

; if window is visible in another frame, then raise it
    (if (and (not (get-buffer-window b))  
	     (get-buffer-window b t))
	(raise-frame
	 (select-frame
	  (window-frame 
	   (get-buffer-window b t)))))

    (pop-to-buffer b)
    (help-mode)
    (not-modified)
    (setq buffer-read-only t)
    (beginning-of-buffer)
    b)
  )

;; these allow pod2text to catch non-found man pages, and if they're perl scripts, try to pod them.
(defun man-cooked-fn () 
  (if (= 0 (length (buffer-string)))
      (let* ((orig-man (cadr (split (cadr (split (buffer-name Man-buffer) "*")))))
	     (f (find-script orig-man)))
	(if f (save-window-excursion (pod2text f (current-buffer)))))))


(add-hook 'Man-cooked-hook 'man-cooked-fn)

(defun pod ()
	"if looking at a perl script containing pod, format it as text."
	(interactive)

	(pod2text (buffer-file-name) (concat (file-name-sans-extension (buffer-name)) " *pod*"))
	)

(defun dired-pod () (interactive)
  (let ((f (dired-get-filename)))
	(pod2text f (concat (file-name-sans-extension f) " *pod*"))))

(add-hook 'dired-load-hook
	  '(lambda () 
	     (define-key  dired-mode-map (vector 'f9) 'dired-pod)
	     )
	  )


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

