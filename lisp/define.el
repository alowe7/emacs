(put 'define 'rcsid 
 "$Id: define.el,v 1.14 2005-06-13 20:41:03 cvs Exp $")

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
(defvar thesaurus-search-pat "http://bartleby.com/cgi-bin/texis/webinator/sitesearch?FILTER=colThesaurus&query=%s")

(defun lookerupper (term filter)
  "look up TERM in bartleby"

  (w3m-goto-url (format filter term))

  )

(defun define (term)
  (interactive (list (string* (read-string (format "term (%s): " (indicated-word))) (indicated-word))))
  "look up TERM in bartleby dictionary"
  (lookerupper term define-search-pat)
  )

; (define "specified")


(defun usage (term)
  "look up TERM in bartleby dictionary"
  (interactive (list (string* (read-string (format "term (%s): " (indicated-word))) (indicated-word))))

  (lookerupper term usage-search-pat)

  )

; (usage "ensure")

(defun refer (term)
  "look up TERM in bartleby all reference"
  (interactive "sterm: ")

  (lookerupper term
	       "http://www.bartleby.com/cgi-bin/texis/webinator/sitesearch?FILTER=colReference&query=%s")
  )

(defun thesaurus (term)
  (interactive (list (string* (read-string (format "term (%s): " (indicated-word))) (indicated-word))))
  "look up TERM in bartleby dictionary"
  (lookerupper term define-search-pat)
  )
(fset 'synonyms 'thesaurus)
; (define "specified")



; hold on a sec.  see w3m-search.el
(defvar google-search-pat
  "http://www.google.com/search?hl=en&ie=UTF-8&oe=UTF-8&q=%s&spell=1" )

(defun google (term)
  "google.  v.t. --  to search for TERM using the search engine du jour"
  (interactive "sgoogle search for: ")

  (lookerupper term google-search-pat)
  )

(require 'ctl-ret)
(define-key ctl-RET-map "g" 'google)
