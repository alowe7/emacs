(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/enoch/host-init.el,v 1.1 2004-01-25 20:35:50 cvs Exp $")

; kim
(add-to-load-path "~x/elisp")

; (require 'xz-loads)
(require 'cat-utils)
(display-time)

(if (eq window-system 'x)
    (progn
      (set-background-color "white")
      (set-foreground-color "black")
      (set-face-attribute 'default nil :font "-adobe-helvetica-medium-r-normal--14-140-75-75-p-77-iso10646-1")
      )
  )

(scroll-bar-mode -1)

; (add-to-list 'Info-default-directory-list "/simon/e/usr/local/lib/info" )
(setenv "PERL5LIB" "/usr/local/site-lib/perl")
(setenv "XDB" "x")
(setenv "XDBHOST" "kim")
(setenv "XDBUSER" "a")

; (require 'xz-loads)
; (define-key xz-map "" 'xz-query-format)

(setq perldir "/usr/lib/perl5/5.6.0/")
					     
(setq *perl-libs* (split (perl-command-2 "map {print \"$_ \"} @INC")))

(defun ff (&optional search-string filter)
  (interactive)
  (if (interactive-p) (call-interactively 'locate)
    (save-window-excursion
      (if (and
	   (condition-case err (funcall 'locate search-string) (error nil))
	   (string-match "Matches for .*: 

" (buffer-string)))
	  (let ((l
		 (remove* "" (mapcar 'trim-white-space (split (buffer-substring (match-end 0) (point-max)) "
")) :test 'string=)))

	    (if filter
		(loop for x in l collect (funcall filter x))
	      l)
	    )
	)
      ))
  )

; e.g. find executable only:
;  (ff "lff" '(lambda (x) (and (string-match "x" (elt (file-attributes x) 8)) x)))
;  (ff "bin" '(lambda (x) (and (string-match "drwx" (elt (file-attributes x) 8)) x)))

(defvar perldir "/usr/lib/perl5/5.6.0")

(setq w3m-home-page "http://kim/kim.nav")

(defun evilnat () t)

(setq mail-default-reply-to "a@alowe.com")
