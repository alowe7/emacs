(put 'xdb 'rcsid
 "$Id: xdb.el,v 1.1 2010-03-07 23:49:08 alowe Exp $")

(chain-parent-file t)

(if (scan-file-p "~/.private/.xdbrc")
    (setq *txdb-options* (list "-b" ($ "$XDB") "-h" ($ "$XDBHOST"))))

