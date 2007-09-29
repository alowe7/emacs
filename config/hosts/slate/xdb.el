(put 'post-xdb 'rcsid
 "$Id: xdb.el,v 1.1 2007-09-29 20:57:12 b Exp $")

(read-string "post-xdb is getting called")

(chain-parent-file t)

(if (scan-file-p "~/.private/.xdbrc")
    (setq *txdb-options* (list "-b" ($ "$XDB") "-h" ($ "$XDBHOST"))))
