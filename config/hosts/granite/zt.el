(put 'zt 'rcsid
 "$Id$")

(defvar *txel-options-file*  (let ((f "~/.private/.zdbrc")) (or (and (file-exists-p f) f) (progn (warn "default *txel-options-file* (%s) not found." f) nil))))

(defun scan-txel-options-file ()
  ; scanning this file should have the side effect of setting these environment variables
  (and (scan-file-p *txel-options-file*)
       (nconc (and (getenv "ZDB") (list "-b" (getenv "ZDB")))
	      (and (getenv "ZDBHOST") (list "-h" (getenv "ZDBHOST"))))
       )
  )

(setq  *txel-options* (scan-txel-options-file))

(chain-parent-file t)
