(put 'xdb 'rcsid
 "$Id: xdb.el,v 1.1 2010-01-06 02:31:53 alowe Exp $")

(chain-parent-file t)

(if (scan-file-p "~/.private/.xdbrc")
    (setq *txdb-options* (list "-b" ($ "$XDB") "-h" ($ "$XDBHOST"))))

