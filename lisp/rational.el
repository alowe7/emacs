(put 'rational 'rcsid "$Id: rational.el,v 1.3 2000-10-03 16:44:07 cvs Exp $")

;; get rid of ansi graphic chars

(defvar nwrang "�")
(defvar nerang "�")
(defvar swrang "�")
(defvar serang "�")
(defvar hbar "�")
(defvar vbar "�")


(defun rationalize () (interactive)
  "make ibm extended charset rational"
  (beginning-of-buffer)
  (replace-string hbar "-")
  (beginning-of-buffer)
  (replace-string vbar "|")
  (beginning-of-buffer)
  (replace-string "�" "{")
  (beginning-of-buffer)
  (replace-string "�" "{")
  (beginning-of-buffer)
  (replace-string "�" "{")
  )

;;(search-forward "�")
;;(search-forward "�")

(defun patch () (interactive)
  "make ibm extended charset rational"
  (beginning-of-buffer)
  (replace-string "�" "|")
  )
