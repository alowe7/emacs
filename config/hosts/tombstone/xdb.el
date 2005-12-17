(put 'post-xdb 'rcsid
 "$Id: xdb.el,v 1.2 2005-12-17 05:01:09 tombstone Exp $")

(read-string "post-xdb is getting called")

(chain-parent-file t)

(if (scan-file-p "~/.private/.xdbrc")
    (setq *txdb-options* (list "-b" ($ "$XDB") "-h" ($ "$XDBHOST"))))
