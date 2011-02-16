(put 'post-xdb 'rcsid
 "$Id: xdb.el 954 2011-02-11 01:55:37Z a $")

; (read-string "post-xdb is getting called")

(chain-parent-file t)

(if (scan-file-p "~/.private/.xdbrc")
    (setq *txdb-options* (list "-b" ($ "$XDB") "-h" ($ "$XDBHOST"))))

(if (scan-file-p "~/.private/.zdbrc")
    (setq *txel-options* (list "-b" ($ "$ZDB") "-h" ($ "$ZDBHOST"))))

