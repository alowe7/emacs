(put 'post-reg 'rcsid
 "$Id: post-reg.el,v 1.1 2003-05-15 21:00:01 cvs Exp $")

(defun lsrun (arg) (interactive "P") 
  "show the contents of the windows/currentversion/run key in the machine hive.
with ARG, show the contents of this key from the user hive"
  (if arg
      (lsreg "user" "software/microsoft/windows/currentversion/run")
    (lsreg "machine" "software/microsoft/windows/currentversion/run")
    )
  )


(defun clsid (id) 
  (interactive (list (string* (read-string (format "classid (%s): " (indicated-word "-"))) (indicated-word "-"))))
  "show the class info for the specified classid"

  (lsreg "machine" (format "software/classes/clsid/{%s}" id))

  )

(define-key reg-view-mode-map "n" '(lambda () (interactive) (next-line 1)))
(define-key reg-view-mode-map "u" '(lambda () (interactive) (previous-line 1)))
(define-key reg-view-mode-map "b" '(lambda () (interactive) (reg-previous-query)))
(define-key reg-view-mode-map " " '(lambda () (interactive) (reg-descend)))
