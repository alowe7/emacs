(put 'post-xdb 'rcsid
 "$Id: xdb.el,v 1.1 2009-11-22 17:45:22 slate Exp $")

; (read-string "post-xdb is getting called")

(chain-parent-file t)

(if (scan-file-p "~/.private/.xdbrc")
    (setq *txdb-options* (list "-b" ($ "$XDB") "-h" ($ "$XDBHOST"))))
