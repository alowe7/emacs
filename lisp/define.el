(put 'define 'rcsid 
 "$Id: define.el,v 1.8 2004-03-03 15:15:18 cvs Exp $")

(require 'w3m)

(defun define0 (term) (interactive "sterm: ")
  (perl-command "define" term)
  (pop-to-buffer " *perl*")
  (rename-buffer (format "*define %s" term) t)
  (beginning-of-buffer)
  (toggle-read-only t)
  (view-mode)
  )

(defvar define-search-pat "http://bartleby.com/cgi-bin/texis/webinator/sitesearch?FILTER=col61&query=%s")

(defun define (term)
"look up TERM in bartleby dictionary"
 (interactive "sterm: ")
  (w3m-goto-url 
   (format define-search-pat term)
   )
  )

; (define "specified")

(defun refer (term)
  "look up TERM in bartleby all reference"
  (interactive "sterm: ")
  (let ((define-serach-pat "http://www.bartleby.com/cgi-bin/texis/webinator/sitesearch?FILTER=colReference&query=%s"))
    (define "power")
    )
  )