(put 'trim 'rcsid
 "$Id: trim.el,v 1.1 2004-03-27 19:03:09 cvs Exp $")
(provide 'trim)

(defun replace-in-string (from to str)
  "replace occurrences of REGEXP with TO in  STRING" 
  (if (string= from "^")
      (concat to (replace-in-string "
" (concat "
" to) str)) 
    (let (new-str
	  (sp 0)
	  )
      (while (string-match from str sp)
	(setq new-str (concat new-str (substring str sp (match-beginning 0)) to))
	(setq sp (match-end 0)))
      (setq new-str (concat new-str (substring str sp)))
      new-str))
  )

(defun trim-trailing-white-space (&optional s) (interactive)
  " trim trailing white space from STRING"
  (if (interactive-p)
      (replace-regexp "[ 	]*$" "")
    (and s 
	 (let* ((p (string-match "[ 	]$" s)))
	   (substring s 0 p)))))

(defun trim-leading-white-space (&optional s) 
  " trim leading white space from STRING"
	(interactive)
  (if (interactive-p)
      (replace-regexp "^[ 	]*" "")
    (and s 
      (replace-in-string "^[ 	]+" "" 
												 (replace-in-string "
[ 	]+" "
" s)
))))

(defun trim-white-space (&optional s) 
	"trim white-space in string.  when called interactively, trims region."
	(interactive)
  (if (interactive-p)
			(save-restriction
			 (narrow-to-region (point) (mark))
			 (goto-char (point-min))
			 (call-interactively 'trim-leading-white-space)
			 (goto-char (point-min))
			 (call-interactively 'trim-trailing-white-space))
    (if (> (length s) 0)
				(trim-trailing-white-space (trim-leading-white-space s))
      s)
    )
  )


(defun trim-buffer ()
  (replace-regexp "[ ]*$" "" nil)
  )

(defun trim-region (begin end)
	(interactive "r")
	(save-excursion
		(narrow-to-region begin end)
		(replace-regexp "[ ]*$" "" nil)
		(widen)
		)
	)

(defun trim-blank-lines (&optional s)
	(interactive)
	(if (and (interactive-p) (null s))
			(let ((s (buffer-substring (point) (mark))))
				(delete-region (point) (mark))
				(insert
	(replace-in-string "^[	 ]*
" "" s)))

	(replace-in-string "^[	 ]*
" "" s)
	)
)

(defun bgets ()
  "do gets on current line from buffer. return as string"
  (let ((x (point)) y z)
    (beginning-of-line)
    (setq y (point))
    (end-of-line)
    (setq z (point))
    (goto-char x)
    (buffer-substring y z)
    )
  )

;; xxx move to indicate, then require.
;; modify indicate fns to use this & take optional string as arg
(defvar end-of-word nil)
(defvar *wordchars* "[ 	]*[^ 	(,;/\=]+[ 	(,;/\=]?" "pattern to match words")

(defun string-to-word (s &optional n)
  " return NTH word in string
 default is n=0 (first word)
if n > # words in string, returns last word.
if n < 0 counts from end of string
"
  (trim-white-space
   (catch 'done
     (let ((z nil) (m (or n 0)))
       (while (string-match *wordchars* s)
	 (let ((x (substring s (match-beginning 0) (setq end-of-word (match-end 0)))))
	   (if (= m 0) (throw 'done x))
	   (push x z)
	   (setq m (1- m))
	   (setq s  (substring s (match-end 0) (length s)))
	   )
	 )
  ;       (read-string (format " (%d: %s)" (min (1- (length z)) n) (nth  z)))
       (throw 'done 
	      (if (< m 0) (nth m z) 
		(nth (min (1- (length z)) m) (reverse z))))
       )
     )
   )
  )
