(put 'define 'rcsid 
 "$Id: define.el,v 1.12 2005-01-24 21:50:14 cvs Exp $")

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
(defvar usage-search-pat  "http://bartleby.com/cgi-bin/texis/webinator/sitesearch?FILTER=col64&query=%s")

(defun define (term)
  "look up TERM in bartleby dictionary"
  (interactive (list (string* (read-string (format "term (%s): " (indicated-word))) (indicated-word))))

  (w3m-goto-url (format define-search-pat term))

  )

; (define "specified")


(defun usage (term)
  "look up TERM in bartleby dictionary"
  (interactive (list (string* (read-string (format "term (%s): " (indicated-word))) (indicated-word))))

  (w3m-goto-url (format usage-search-pat term))

  )

; (usage "ensure")

(defun refer (term)
  "look up TERM in bartleby all reference"
  (interactive "sterm: ")
  (let ((define-serach-pat "http://www.bartleby.com/cgi-bin/texis/webinator/sitesearch?FILTER=colReference&query=%s"))
    (define "power")
    )
  )

; hold on a sec.  see w3m-search.el
(defvar google-search-pat
  "http://www.google.com/search?hl=en&ie=UTF-8&oe=UTF-8&q=%s&spell=1" )

(defun google (term)
  "google.  v.t. --  to search for TERM using the search engine du jour"
  (interactive "sterm: ")
  (w3m-goto-url 
   (format google-search-pat term)
   )
  )