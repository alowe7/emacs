
(defun hcl (pat) (interactive "spat: ")
(egrep (format "-i %s f:/support/hcl.txt" pat)))