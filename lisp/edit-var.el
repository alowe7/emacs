(put 'edit-var 'rcsid
 "$Id: edit-var.el,v 1.1 2003-03-03 20:26:42 cvs Exp $")

(defun edit-var (var)
  (interactive
   (list (completing-read "Variable: " obarray nil t))
   )
  (let* ((b (get-buffer-create "*edit*"))
	 (sym (intern var))
	 (val (save-window-excursion (xa "edit it" (join (eval sym) "
") b))))
    (set sym (split val "
"))
    (kill-buffer b)
;    (describe-variable sym)
;    (switch-to-buffer "*Help*")
    )
  )

(edit-var "process-environment")
