(put 'xdb 'rcsid
 "$Id: xdb.el,v 1.3 2004-08-24 02:00:13 cvs Exp $")

(chain-parent-file t)

(require 'sh)

(if (scan-file-p "~/.private/.xdbrc")
    (setq *txdb-options* (list "-b" ($ "$XDB") "-h" ($ "$XDBHOST"))))
