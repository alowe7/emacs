(require 'w3m)

(defvar *bug-history* nil)

(defun bug (n)
  (interactive 
   (list (car (read-from-string (read-input (format "n (%s): " (indicated-word)) nil *bug-history* (indicated-word))))))
  (w3m-goto-url-new-session
   (format "http://bjbugzilla.inhouse.broadjump.com/show_bug.cgi?id=%d" n))
  )

; (bug 26043)

