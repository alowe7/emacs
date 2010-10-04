(put 'rational 'rcsid 
 "$Id$")

;; get rid of ansi graphic chars

(defvar nwrang "Ú")
(defvar nerang "¿")
(defvar swrang "À")
(defvar serang "Ù")
(defvar hbar "Ä")
(defvar vbar "³")


(defun rationalize () (interactive)
  "make ibm extended charset rational"
  (beginning-of-buffer)
  (replace-string hbar "-")
  (beginning-of-buffer)
  (replace-string vbar "|")
  (beginning-of-buffer)
  (replace-string "¤" "{")
  (beginning-of-buffer)
  (replace-string "‡" "{")
  (beginning-of-buffer)
  (replace-string "µ" "{")
  )

;;(search-forward "³")
;;(search-forward "µ")

(defun patch () (interactive)
  "make ibm extended charset rational"
  (beginning-of-buffer)
  (replace-string "µ" "|")
  )
