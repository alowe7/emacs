(put 'fx 'rcsid
 "$Id: fx.el,v 1.6 2003-11-24 21:50:38 cvs Exp $")

(require 'cat-utils)
(require 'xdb)

(defvar *fx-host* "localhost")
(defvar *fx-db* "a@fx")

(defun fx (pat)
"find files using db"
  (interactive "sPat: ")

  (let ((*txdb-options* `("-h" ,*fx-host* "-b" ,*fx-db*))
	(x-query-mode-hook 'fb-mode))
    (x-query-1 
     (format "select * from f where %s" (regexp-to-sql pat))
     )
    )
  )

(defun fx2 (pat1 pat2)
  "find files using db"
  (interactive "sPat1: \nsPat2: ")

  (let ((*txdb-options* `("-h" ,*fx-host* "-b" ,*fx-db*))
	(x-query-mode-hook 'fb-mode))
    (x-query-1 
     (format "select * from f where %s and %s" (regexp-to-sql pat1) (regexp-to-sql pat2))
     )
    )
  )

(defun fxt (pat1 ext)
  "find files using db"
  (interactive "sPat1: \nsExtension: ")

  (let ((*txdb-options* `("-h" ,*fx-host* "-b" ,*fx-db*))
	(x-query-mode-hook 'fb-mode))
    (x-query-1 
     (format "select * from f where %s and %s" (regexp-to-sql pat1) (regexp-to-sql (format "\\.%s$" ext)))
     )
    )
  )

(defun regexp-to-sql (pat)
  " convert some basic regxp syntax to sql pattern matching syntax patterns"
  (mapconcat '(lambda (x) 
		(if (string-match "\\^" x)
		    (setq x (substring x (match-end 0)))
		    (setq x (concat "%%" x))
		  )
		(if (string-match "\\$" x) 
		    (setq x (substring x 0 (match-beginning 0)))
		    (setq x (concat x "%%" )))
		(format "name like '%s'" x)

		)
	     (split pat "|")
	     " and ")
  )
; (regexp-to-sql "foo")
; (regexp-to-sql "foo$")
; (regexp-to-sql "^foo")
; (regexp-to-sql "^foo|bar$")

(provide 'fx)
