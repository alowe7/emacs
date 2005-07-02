(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/alowe1/host-init.el,v 1.38 2005-07-02 20:12:18 cvs Exp $")

(require 'default-frame-configurations)

; (default-frame-configuration "tahoma")
; (default-frame-configuration "arial")
(default-frame-configuration "courier new")

(setq default-frame-alist initial-frame-alist)

(add-hook 'people-load-hook (lambda () ; (require 'worlds)
			      (setq *people-database*
				    (nconc 
  ; xxx todo: put (get-directory-files (expand-file-name ...)) into xwf if F is a dir, add optional argz
  ;				     (last (get-directory-files (xwf "n" "broadjump") t "people.*\.csv$"))
				     (last (get-directory-files (fw "m") t "phone.*.csv$"))
				     (and (file-exists-p "~/n/people") (list "~/n/people"))))))
(add-hook 'xz-load-hook 
	  '(lambda ()
	     (mapcar
	      '(lambda (x) (load x t t)) 
	      '("xz-compound" "xz-fancy-keys" "xz-constraints"))))

(add-hook 'world-init-hook '(lambda ()
			      ;; 
			      ;; 			      (setq *howto-path* 
			      ;; 				    (loop for w in (la) 
			      ;; 					  when (file-exists-p (fwf "n" w))
			      ;; 					  collect (fwf "n" w)))
			      ;; 
			      ;; 			      (setq *howto-alist* 
			      ;; 				    (loop
			      ;; 				     for x in *howto-path*
			      ;; 				     with l = nil
			      ;; 				     nconc (loop for y in (get-directory-files x)
			      ;; 						 collect (list y x)) into l
			      ;; 				     finally return l)
			      ;; 				    )

  ; 			      (load "world-advice")
			      (load "post-worlds")
			      )
	  )

(setq *shell-track-worlds* t)

(require 'xz-loads)
(setq *xz-show-status* nil)
(setq *xz-squish* 4)

(setq gnus-select-method '(nntp "news.eclipse.org"))
; (gnus-fetch-group "eclipse.tools")
; '(nntp "news.inhouse.broadjump.com"))
; (setenv "NNTPSERVER" "news.inhouse.broadjump.com")

(require 'gnuserv)
(display-time)

(make-variable-buffer-local 'shell-prompt-pattern)
(set-default 'shell-prompt-pattern
	     (set 'shell-prompt-pattern "^[a-zA-Z0-9]+[>$%] *"))

(setq *default-swordfile* "~/.private/bj")

; man don't work with default path
(load-library "post-man")

(setq grep-command "grep -n -i -e ")

; unnecessary performance hack
(setq font-lock-support-mode nil)
; (setq font-lock-support-mode 'fast-lock-mode)
; (setq font-lock-support-mode 'lazy-lock-mode)

(add-hook 'perl-mode-hook (lambda () (font-lock-mode)))
(add-hook 'java-mode-hook 'my-java-mode-hook)
(defun my-java-mode-hook ()
  ; there's bugs handling chars like ' in comments
  ; this still screws up paren-matching
  (setq font-lock-defaults
	'((java-font-lock-keywords-1
	   java-font-lock-keywords-2
	   java-font-lock-keywords-3))
	font-lock-keywords-only t)
  (condition-case err
      (font-lock-mode 1)
    (error 
  ; (debug)
     )
    )

  ; font locking is broken in java mode
  (set-buffer-modified-p nil)

;  (font-lock-fontify-buffer) 
  ; this ain't so swift neither 
  ;			    (setq c-syntactic-indentation nil)
  )
; (pop java-mode-hook)

(require 'reg)

(defvar java-home
  (string* (getenv "JAVA_HOME")
	   (expand-file-name
	    (chomp (queryvalue "machine" "software/javasoft/java development kit/1.4" "javahome")))
	   )
  )

; use working versions. will this stuff ever stabilize?
(let ((r '(
	   ("site-lisp/tw-3.01" "/x/tw/site-lisp")
	   ("site-lisp/db-1.0" "/x/db/site-lisp")
	   ("site-lisp/xz-3.1" "/x/xz/site-lisp")
	   ("site-lisp/tx-1.0" "/x/elisp")
	   ))
      )
  (loop for e in r do 
	(setq load-path
  ; first remove published versions, if any
	      (nconc (remove-if '(lambda (x) (string-match (car e) x)) load-path)
  ; then add working versions
		     (cdr e))
	      )
	)
  )

(add-to-load-path "/u/emacs-w3m/emacs-w3m")
(autoload 'w3m "w3m" "Interface for w3m on Emacs." t)

; all kinds of crap here
(loop for d in '("/z/el" "/z/pl" "/z/soap" "/z/gpg")
      do
      (add-to-load-path d t)

  ; and some here too
      (condition-case x (load (concat d "/.autoloads")) (error nil))
      )

; find-script will look along path for certain commands 
(addpathp "/z/pl" "PATH")

(addpathp "/j2sdk1.4.2_04/bin" "PATH")

; this ensure calendar comes up in a frame with a fixed-width font
(load-library "mycal")

; xxx check out why this isn't autoloading
(load-library "post-bookmark")

; (load-library "post-help")
(load-library "fixframe")
(load-library "unbury")

(fset 'try 'condition-case)

(provide 'host-init)