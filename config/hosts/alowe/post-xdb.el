(put 'post-xdb 'rcsid
 "$Id: post-xdb.el,v 1.3 2004-04-05 15:30:41 cvs Exp $")

(chain-parent-file t)

(require 'ctl-slash)
(define-key ctl-/-map "x" 'xdb)
(define-key ctl-/-map "q" 'xq)
(define-key ctl-/-map "t" 'xt)
(define-key ctl-/-map "l" 'xl)
(define-key ctl-/-map "n" 'xn)
(define-key ctl-/-map "w" 'xql)

(define-key ctl-/-map "\C-l" 'xlq) ; not to be confused with xql ...?-)

; (add-hook 'xdb-init-hook 'xdb-login)
(add-txdb-option "-b"  "a/q-1pzl@x" )
(if (evilnat)
    (add-txdb-option "-h"  "enoch:3306" )
    (add-txdb-option "-h"  "localhost:13306" ))
; *txdb-options*

(setq *local-txdb-options* '("-h" "-" "-b" "upm" "-u" "a"))
