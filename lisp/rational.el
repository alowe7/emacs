(put 'rational 'rcsid 
 "$Id$")

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
