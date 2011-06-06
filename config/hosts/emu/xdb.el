(put 'xdb 'rcsid
 "$Id$")

(chain-parent-file t)

(if (scan-file-p "//nathan/C/home/a/.private/.xdbrc")
    (setq *txdb-options* (list "-b" ($ "$XDB") "-h" ($ "$XDBHOST"))))

