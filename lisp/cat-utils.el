(put 'cat-utils 'rcsid
 "$id: cat-utils.el,v 1.4 2004/03/11 19:01:01 cvs exp $")
;; utilities for converting between strings and lists or vectors of strings

(require 'cl)

;;; todo generalize this by adding fn to apply
(defun catvectorint (s &optional c)
  "list is a string of integers separated by character c (default ':')
  return its value as a vector of ints"
  (interactive "spath: ")
  (apply 'vector (catlistint s c))
  )


(defun catlistint (s &optional c)
  "list is a string of ints separated by character c (default ':')
  return its value as a list of ints"
  (interactive "spath: ")
  (mapcar 'string-to-int (catlist s c))
  )

(defun catvector (s &optional c)
  "list is a string of words separated by character c (default ':')
  return its value as a list of strings"
  (interactive "spath: ")
  (apply 'vector (mapcar 'intern (catlist s c)))
  )

(defun catlist (s &optional c)
  "string is a string of words separated by character c (default ':')
  return its value as a list of strings"
  (interactive "spath: ")
  (let* ((cc (or c ?:))
	(pat (format "[^%c]*%c" cc cc))
	(l nil)
	(result nil))
    (while s
      (let ((w (and (string-match pat s)
		    (substring s (match-beginning 0)
			       (1- (match-end 0))))))
	(setq l (append l (list (or w s))))
	(if w 
	    (setq s (substring s (match-end 0)))
	  (setq s nil))
	))
    (dolist (x l) (and (> (length x) 0) (setq result (nconc result (list x)))))
    result
  )
)

(defun catfile (f &optional c)
  "file is a file containing a list of words separated by character c (default '\n')
  return its value as a list of strings"
  (interactive "spath: ")
  (catlist (read-file f) (or c ?
														 ))
)

(defun catalist (s &optional c)
  "list is a string of words separated by character c (default ':')
  return its value as an alist of strings"
  (interactive "spath: ")
  (let* ((cc (or c ?:))
	(pat (format "[^%c]*%c" cc cc))
	(l nil)
	(result nil))
    (while s
      (let ((w (and (string-match pat s)
		    (substring s (match-beginning 0)
			       (1- (match-end 0))))))
	(setq l (append l (list (or w s))))
	(if w 
	    (setq s (substring s (match-end 0)))
	  (setq s nil))
	))
    (dolist (x l) (and (> (length x) 0) (setq result (nconc result (list (list x))))))
    result
  )
)

(defun catpath (path &optional c)
  "path is an environment variable representing a path.  
  return its value as a list of strings
  elements of path are separated by character c (default ':')
"
  (interactive "spath: ")

  (let ((c (if (or (eq c 'w32)
		   (string-match ":\\\\"  path))
		semicolon
		(or c ":"))))
		 
    (loop for x in (split (getenv path) c)
	  collect (expand-file-name x))
    )
  )

(defun uncatlist (list &optional s)
  " list is a list of strings.  concat them separated by optional
string s (default \":\")"

  (let (result (ps (or s ":")))
    (loop for x in list do
	  (setq result (concat result x ps)))
    (substring result 0 (- (length ps)))))

(defun addpathp (path element)
  " add element to path if not already on it"
  (let ((pl (catpath path)))
    (if (not (catch 'done
	       (dolist (x (catpath path))
		 (if (string-equal x element)
		     (throw 'done t)))))
	  (setenv path (uncatlist (append pl (list element))))
      )
    )
  )

;; perl like apis 

(defun join (v &optional pat)
  "concat sequence as strings with optional separator
sequence may be a vector or list.
separator may be a string, or charcode
default is ':'
"
  (let* (
	 (patp (cond ((stringp pat) pat)
		     ((numberp pat) (format "%c" pat))
		     (t ":")))
	 (seq 
	  (cond ((vectorp v) (loop for x across v
				   collect
				   (concat x patp)))
		((listp v) (loop for x in v 
				 collect
				 (concat x patp)))
		(t v)))
	 )
    (if (> (length seq) 0) ; remove the last pat
	(substring (apply 'concat seq)
		   0 (- (length patp)))
      "")
    )
  )

; (join (list "a" "b" "c"))

(defun split (s &optional pat)
  (and (string* s)
       (let* (
	      (patp (cond ((stringp pat) pat)
			  ((numberp pat) (format "%c" pat))
			  (t "[ 	
]")))
	      (i 0)
	      v)
	 (loop
	  while (string-match patp (substring s i))
	  do
	  (push (substring s i (+ i (match-beginning 0))) v)
	  (setq i (+ i (match-end 0)))
	  finally
	  (push (substring s i) v)
	  )
  ; remove trailing trivial matches
	 (while (not (string* (car v))) (pop v))
	 (reverse v)))
  )

; (split "abcd efgh, ijkl	mnop  " )

;; perl push and pop operate on the tail of the list
;; perl shift and unshift operate on the head

;; since emacs push and pop operate on the head of the list
;; we define shift and unshift to operate on the tail

;; heads up!

(defun shift (l) 
  (let ((v (last l)))
    (nbutlast l)
    v)
  )


; (shift '(a b c))

(defun unshift (l v) 
  (nconc l (list v))
  )

; (let ((l '(a b c)))  (unshift l 'd) l)

(defun shift-word (s)
  "break string into (first-word . rest)"
  (if (string-match "\\W" s)
      (cons (substring s 0 (match-beginning 0)) (substring s (match-end 0))))
  )

; (shift-word "foo;bar baz bo")

(defun chop (s)
  " chop trailing char"
  (substring s 0 -1)
  )

(defun chomp (s &optional c)
  "maybe chop trailing linefeed"
  (cond ((not (string* s)) s)
	((eq (aref (substring s -1) 0) (or c ?
					   )	  )
	 (substring s 0 -1))
	(t s))
  )

(provide 'cat-utils)
