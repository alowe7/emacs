(put 'post-xdb 'rcsid
 "$Id: post-xdb.el,v 1.1 2004-03-04 05:34:19 cvs Exp $")

(chain-parent-file t)

(require 'ctl-slash)
(define-key ctl-/-map "x" 'xdb)

(if (evilnat)
    (setq *txdb-options* '("-b" "a/q-1pzl@x" "-h" "enoch:3306"))
  (setq *txdb-options* '("-b" "a/q-1pzl@x" "-h" "localhost:13306"))
  )
