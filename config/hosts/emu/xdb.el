(put 'xdb 'rcsid
 "$Id: xdb.el,v 1.1 2005-09-30 03:39:26 noah Exp $")

(chain-parent-file t)

(if (scan-file-p "//nathan/C/home/a/.private/.xdbrc")
    (setq *txdb-options* (list "-b" ($ "$XDB") "-h" ($ "$XDBHOST"))))

