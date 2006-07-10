(put 'post-locate 'rcsid
 "$Id: post-locate.el,v 1.1 2006-07-10 23:55:20 tombstone Exp $")

(chain-parent-file t)

(require 'cat-utils)
(require 'cl)

(defun cmp* (a b)
  "like `cmp' but usable by `sort*'
"
  (< (cmp a b) 0)
  )

(defvar *locate-deprecated* '("^/misc") "list of regexps that are of less interest when locating")

(defun preferred-locate-order (x y) 

  (catch 'done
    (loop for pat in *locate-deprecated*
	  do
	  (if (string-match pat x)
	      (if (string-match pat y) (throw 'done (cmp* x y))
		(throw 'done nil))
	    (if (string-match pat y) (throw 'done t))
	    )
	  )

  ; neither match anything in deprecated list
    (cmp* x y)
    )
  )

; (sort* '("/misc" "/home" "/a") 'preferred-locate-order)


; in addition to whatever other advice locate has, sort lines with deprecation

(defadvice locate (around 
		   preferred-locate-order
		   first
		   activate)
  ""

  ad-do-it


  (if (< (count-lines (point-min) (point-max)) 1000)
      (let* ((l (split (buffer-string) "\n"))
	     (meta
	      (cons (nthcdr 2 l) (progn (setcdr (nthcdr 1 l) nil) l))))

	(erase-buffer)
	(insert (join (nconc (cdr meta) (sort* (car meta) 'preferred-locate-order)) "\n"))
	)
    )

  )

; (if (ad-is-advised 'locate) (ad-unadvise 'locate))

