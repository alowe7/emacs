(put 'nums 'rcsid 
 "$Id: nums.el,v 1.7 2001-11-02 21:30:28 cvs Exp $")
(provide 'nums)

(defun exp (n m)
  " compute n ** m "
  (if (= m 0) 1
    (let ((s "(* "))
      (while (> m 0) 
	(setq s (concat s (int-to-string n) " "))
	(setq m (1- m)))
      (eval (read  (concat s ")")))
      )
    )
  )

(defun hex (s)
  " convert integer arg S as hex formatted string
S may also be a string representation of a decimal number "
  (interactive "sdecimal number: ")
  (let ((h (format "0x%0x" (if (integerp s) s (string-to-int s)))))
    (if (interactive-p) 
	(message h) h))
)

(defun dec (s &optional m)
" return decimal equivalent of hex string S
  with optional second arg, display result.
" 
  (interactive "shex number: ")
  (let* ((s (cond ((stringp s) s) ((atom s) (symbol-name s)) ((integerp s) (format "%d" s))))
	 (al '(("0" . 0) ("1" . 1) ("2" . 2) ("3" . 3) ("4" . 4) ("5" . 5) ("6" . 6) ("7" . 7) ("8" . 8) ("9" . 9) 
	       ("a" . 10) ("b" . 11) ("c" . 12) ("d" . 13) ("e" . 14) ("f" . 15)
	       ("A" . 10) ("B" . 11) ("C" . 12) ("D" . 13) ("E" . 14) ("F" . 15)
	       ))
	 (v 0) (p 0) (b 16) (n (length s)))

    (while (> n 0)
      (let
	  ((c (substring s (1- n) n)))
	(if 
	    (eq (string-to-char c) (string-to-char "x"))
	    (setq n 0)
	  (progn
	    (setq v (+ v 
		       (* (cdr (assoc c al)) (exp b p))
		       )
		  )
	    (setq p (1+ p))
	    (setq n (1- n))
	    )
	  )
	)
      )
    (if (or (interactive-p) m) (message "%d" v) v)
    )
  )


(defun indicated-float ()
  "convert indicated word from a hex number to floating point"
  (interactive)
  (message (clean-string (eval-process "a2f" (indicated-word))))
  )

(defun insert-indicated-float ()
  "convert indicated word from a hex number to floating point"
  (interactive)
  (insert (format " %s " (clean-string (eval-process "a2f" (indicated-word)))))
  (kill-word 1)
  )

(defun show-float (&optional arg)
  "show hex representaion of indicated floating point number
with arg, prompt for number.
"
  (interactive "P")
  (message (clean-string (eval-process "f2a" (or (and arg (read-string "fp: ")) (indicated-word)))))
  )


(defun indicated-dec ()
  "convert indicated word from a hex number to decimal"
  (interactive)
  (dec (indicated-word) t))


(defun indicated-hex ()
  "convert indicated word from a decimal number to hex"
  (interactive)
  (hex (indicated-word)))


(defun ascii (s)
  "s is a string representing a sequence of hex numbers seperated by whitespace.  
   return the corresponding ascii string
   null terminates"
  (interactive "s")
  (let ((c nil)
	(ns ""))
    (while (and (> (length s) 0) (not (equal c "")))
      (setq c (format "%c" (dec (substring s 0 2))))
      (setq ns (concat ns c))
      (if (< (length s) 3)
	  (setq s "")
	(setq s (substring s 2 (length s))))
      )
    (message ns)
    )
  )

(defun ascii-region (beg end)
  "convert region of hex numbers to corresponding ascii string"
  (interactive "r")
  (ascii (clean-string (buffer-substring beg end)))
  )

(defun ascii2 (s)
  "s is a string. return the ascii of the hex version of the string"
  (while (> (length s) 0)
    (insert (format "%x"  (string-to-char s)))
    (setq s (substring s 1 (length s)))))

(defun ascii-region2 (beg end)
  "convert region of text to hex"
  (ascii2 (buffer-substring beg end)))

(defun number-lines (&optional base column separator)
  " insert line numbers in region starting at optional number BASE.
  if called interactively line numbers are inserted at the current column (default 0)"
  (interactive "P")
  (save-excursion
    (let* 
	((i (if (and (interactive-p) (not (null base)) (listp base)) (car base) 0))
	 (z (+ i (count-lines (point) (mark))))
	 (goal-column (if (interactive-p) (current-column) column))
	 (separator (or separator " "))
	 )
      (narrow-to-region (save-excursion (beginning-of-line) (point)) (mark))
      (beginning-of-buffer)
      (while (< i z)
	(insert (concat (format "%03d" i) separator)) 
	(next-line 1)
	(setq i (1+ i))
	)
      )
    (widen)
    )
  )


(defun ascii-word (arg)
  "point is on a word of ascii text. decode it.
with arg, use region."
  (interactive "P")
  (let ((s (if arg 
	       (replace-letter (buffer-substring (point) (mark)) " " nil)
	     (indicated-word)))
	l s2) 
    (while (> (length s) 0) 
      (let* ((len (length s))
	     (m (min 2 len))) 
	(push (format "%c" (dec (substring s 0 m))) l) 
	(setq s (substring s m (length s)))))
    (while l (setq s2 (concat (pop l) s2)))
    (message s2)))

(defun ief ()
"(eval-process "a2f" (indicated-word))"
  (interactive)
  (let ((x (clean-string (eval-process "a2f" (indicated-word)))))
    (if buffer-read-only
	(message x)
	(save-excursion
	  (end-of-line)
	  (insert (format "		# %s" x))))))

(if (boundp 'shell-mode-map)
(define-key shell-mode-map "a" 'ascii-word))
