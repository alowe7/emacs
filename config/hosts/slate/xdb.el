(put 'post-xdb 'rcsid
 "$Id: xdb.el,v 1.2 2008-10-04 00:54:51 slate Exp $")

; (read-string "post-xdb is getting called")

(chain-parent-file t)

(if (scan-file-p "~/.private/.xdbrc")
    (setq *txdb-options* (list "-b" ($ "$XDB") "-h" ($ "$XDBHOST"))))
