(put 'edit-var 'rcsid
 "$Id: edit-var.el,v 1.2 2003-08-29 16:50:28 cvs Exp $")

(defun edit-var (var)
  (interactive
   (list (completing-read "Variable: " obarray nil t))
   )
  (let* ((b (get-buffer-create "*edit*"))
	 (sym (if (stringp var) (intern var) var))
	 (val (save-window-excursion (xa "edit it" (join (eval sym) "
") b))))
    (set sym (split val "
"))
    (kill-buffer b)
;    (describe-variable sym)
;    (switch-to-buffer "*Help*")
    )
  )

; (edit-var "process-environment")
; (edit-var '*txdb-options*)
