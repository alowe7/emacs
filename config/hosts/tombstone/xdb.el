(put 'post-xdb 'rcsid
 "$Id$")

(read-string "post-xdb is getting called")

(chain-parent-file t)

(if (scan-file-p "~/.private/.xdbrc")
    (setq *txdb-options* (list "-b" ($ "$XDB") "-h" ($ "$XDBHOST"))))
