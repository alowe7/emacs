(put 'xdb 'rcsid
 "$Id: xdb.el,v 1.2 2004-08-24 01:59:57 cvs Exp $")

(chain-parent-file t)

(if (scan-file-p "~/.private/.xdbrc")
    (setq *txdb-options* (list "-b" ($ "$XDB") "-h" ($ "$XDBHOST"))))
