(put 'post-xdb 'rcsid 
 "$Id$")


(if (scan-file-p "~/.private/.xdbrc")
    (setq *txdb-options* (list "-b" ($ "$XDB") "-h" ($ "$XDBHOST"))))

(if (scan-file-p "~/.private/.zdbrc")
    (setq *txel-options* (list "-b" ($ "$ZDB") "-h" ($ "$ZDBHOST"))))


(add-hook 'x-query-mode-hook '(lambda ()
				(loop for x across "/:\.-" do (modify-syntax-entry x "w"))
				))

; (pop x-query-mode-hook)
; (run-hooks (quote x-query-mode-hook))

