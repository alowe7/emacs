(put 'post-xdb 'rcsid
 "$Id: xdb.el,v 1.2 2004-10-15 22:13:59 cvs Exp $")

(chain-parent-file t)

(if (scan-file-p "~/.private/.xdbrc")
    (progn
      (add-txdb-option "-b" ($ "$XDB"))
      (add-txdb-option "-h" ($ "$XDBHOST"))
      *txdb-options*
      )
  )
