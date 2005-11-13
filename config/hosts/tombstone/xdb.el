(put 'post-xdb 'rcsid
 "$Id: xdb.el,v 1.1 2005-11-13 15:42:40 cvs Exp $")

(chain-parent-file t)

(if (scan-file-p "~/.private/.xdbrc")
    (setq *txdb-options* (list "-b" ($ "$XDB") "-h" ($ "$XDBHOST"))))
