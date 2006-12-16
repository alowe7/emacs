(put 'xdb 'rcsid
 "$Id: xdb.el,v 1.1 2006-12-16 21:01:28 noah Exp $")

(chain-parent-file t)

(if (scan-file-p "//nathan/C/home/a/.private/.xdbrc")
    (setq *txdb-options* (list "-b" ($ "$XDB") "-h" ($ "$XDBHOST"))))

