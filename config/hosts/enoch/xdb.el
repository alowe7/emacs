(put 'post-xdb 'rcsid
 "$Id: xdb.el,v 1.3 2005-01-18 22:35:08 cvs Exp $")

(chain-parent-file t)

(if (scan-file-p "~/.private/.xdbrc")
    (setq *txdb-options* (list "-b" ($ "$XDB") "-h" ($ "$XDBHOST"))))
