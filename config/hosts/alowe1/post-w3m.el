(put 'post-w3m 'rcsid
 "$Id: post-w3m.el,v 1.1 2005-01-20 22:25:56 cvs Exp $")

(chain-parent-file t)

(require 'pluck)

;; this depends on remove duplicates removing the first occurrence
(setq 
 *all-docs-alist*
 (sort
  (remove-duplicates
   (nconc
    *all-docs-alist*
    (pluck "http://localhost/specs.nav")
    )
   :test (lambda (x y) (string= (car x) (car y))))
  '(lambda (x y) (string< (car x) (car y))))
 )

