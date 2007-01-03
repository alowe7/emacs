(put 'xdb 'rcsid
 "$Id: xdb.el,v 1.2 2007-01-03 00:04:28 noah Exp $")

(chain-parent-file t)

(if (scan-file-p "~/.private/.xdbrc")
    (setq *txdb-options* (list "-b" ($ "$XDB") "-h" ($ "$XDBHOST"))))

