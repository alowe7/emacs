(put 'qsave 'rcsid
     "$Id: qsave.el,v 1.3 2003-08-29 16:50:28 cvs Exp $")

;; by Andy Lowe (c) 1993, 1994, 1995, 1996, 1997, 1998

;;  You are permitted to copy, modify and redistribute this software and associated documentation.
;;  You may not change this copyright notice, and it must be included in any copy made.
;;  
;;  THIS PROGRAM IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
;;  EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;;  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
;;  

(require 'cl)

;; retain command output on the qsave property of the interned buffer name

(defstruct qsave-cell
  "qsave context cell" 
  contents label data)

;; currently not enforced

(defvar *maximum-qsaved-output-depth* nil
  "if set, output search list is not to exceed this depth")

(defun qsaved-output (b &optional v)
 
  (let* ((a (intern (buffer-name b))))
    (if v
	(put a 'qsave v))
    (get a 'qsave))
  )

(defun qsaved-output-index (b &optional v)
  (save-excursion
    (set-buffer b)
    (let* ((a (intern (buffer-name))))
      (if v
	  (put a 'qsaved-index v))
      (get a 'qsaved-index))
    )
  )

(defun prune-search (&optional n b)
  " prune to optional depth N the search list associated with BUFFER.
default depth is 0, default buffer is current-buffer. 
updates window to reflect new top of list.
returns newly current cell data, if any
"
  (interactive "ndepth of saved list: ")
  (save-excursion
    (and b (set-buffer b))
    (let* ((a (intern (buffer-name)))
	   (n (or n 0))
	   (v (get a 'qsave))
	   (len (length v)))
      (cond ((= n 0) 
	     (progn 
	       (put a 'qsave nil)
	       (setq buffer-read-only nil)
	       (erase-buffer)
	       (setq buffer-read-only t)
	       (put a 'qsaved-index 0)
	       (setq mode-line-buffer-identification nil)
	       (setq mode-line-process (format " %d/%d" (length v) (length v)))
	       ))
	    ((> len n)
	     (let ((m (- len n))
		   ss)
	       (while v (push (pop v) ss))
	       (while (> m 0) (progn
				(pop ss)
				(setq m (1- m))))
	       (while ss (push (pop ss) v))
	       (let* ((j (length v))
		      (x (nth (1- j) v)))
		 (erase-buffer)
		 (insert (qsave-cell-contents x))
		 (setq mode-line-buffer-identification (qsave-cell-label x))
		 (set-window-start (display-buffer (current-buffer)) 1)
		 (setq mode-line-process (format " %d/%d" j j))
		 (put a 'qsaved-index j)
		 (put a 'qsave v)
		 (qsave-cell-data x)
		 )
	       )
	     )
	    )
      (force-mode-line-update)
      )
    )
  )


;; the qsave property of the interned buffer name holds a stack
;; of previous queries

(defun qsave-search (b l &optional d)
  "push contents of BUFFER and associated LABEL along with optional DATA
into internal stack"
  (save-excursion
    (set-buffer b)
    (let* ((a (intern (buffer-name)))
	   (v (get a 'qsave))
	   (x (make-qsave-cell :contents (buffer-substring (point-min) (point-max))
			       :label l
			       :data d
			       )))

      (put a 'qsave (push x v))

      ;; now looking at most recent one
      (put a 'qsaved-index 0)
      (setq mode-line-process (format " %d/%d" (length v) (length v)))
      (setq mode-line-buffer-identification l)
      )
    )
  )


(defun previous-qsave-search (&optional b)
  " move to previous search context in the stack of contexts 
associated with optional buffer B (default `current-buffer')
returns data on cell, if any.
"
  (interactive)
  (let* ((a (intern (buffer-name (or b (current-buffer)))))
	 (v (get a 'qsave))
	 (i (get a 'qsaved-index))
	 (len (length v)))
    (if (not v) 
	(progn 
	  (message "no saved command output")
	  nil)
      (if (< i (1- len))
	  (let* ((j (1+ i))
		 (x (nth j v))
		 (buffer-read-only nil))
	    (erase-buffer)
	    (insert (qsave-cell-contents x))
	    (setq mode-line-buffer-identification (qsave-cell-label x))
	    (beginning-of-buffer)
	    (set-window-start (display-buffer (current-buffer)) 1)
	    (setq mode-line-process (format " %d/%d" (- len j) len))
	    (put a 'qsaved-index j)
	    (qsave-cell-data x)
	    )
	(progn
	  (message "bottom of saved command output list")
	  nil)
	)
      )
    )
  )

(defun next-qsave-search  (&optional b)
  " move to next search context in the stack of contexts 
associated with optional buffer B (default `current-buffer')
returns data on cell, if any.
"
  (interactive)
  (let* ((a (intern (buffer-name (or b (current-buffer)))))
	 (v (get a 'qsave))
	 (i (get a 'qsaved-index))
	 (len (length v)))
    (if (not v) 
	(progn 
	  (message "no saved command output")
	  nil)
      (if (> i 0)
	  (let* ((j (1- i))
		 (x (nth j v))
		 (buffer-read-only nil))
	    (erase-buffer)
	    (insert (qsave-cell-contents x))
	    (setq mode-line-buffer-identification (qsave-cell-label x))
	    (beginning-of-buffer)
	    (set-window-start (display-buffer (current-buffer)) 1)
	    (setq mode-line-process (format " %d/%d" (- len j) len))
	    (put a 'qsaved-index j)
	    (qsave-cell-data x)
	    )
	(progn
	  (message "top of saved command output list")
	  nil)
	)
      )
    )
  )

;; minor mode for qsave -- used for readonly buffers, where we can clobber the "p" and "n" keys.
;; warning -- no way to back out these key bindings

(defvar qsave-mode nil)
(make-variable-buffer-local 'qsave-mode)

(defvar saved-key-bindings nil)
(make-variable-buffer-local 'saved-key-bindings)

(defun roll-qsave () (interactive) (previous-qsave-search (current-buffer)))
(defun roll-qsave-1 () (interactive) (next-qsave-search (current-buffer)))

;  (condition-case x (cd (previous-qsave-search (current-buffer))) (error nil))

(defun qsave-mode (arg)
  (let ((prev-qsave-mode qsave-mode))
    (setq qsave-mode
	  (if (null arg) (not qsave-mode)
	    (> (prefix-numeric-value arg) 0)))
    (if qsave-mode 
					; entering
	(unless prev-qsave-mode
	  (progn
	    (setq saved-key-bindings (list
				      (cons "p" (local-key-binding "p"))
				      (cons "n" (local-key-binding "n"))
				      ))
	    (local-set-key "p" 'roll-qsave)
	    (local-set-key "n" 'roll-qsave-1)
	    ))
					; leaving
      (progn
	(and (assoc "p" saved-key-bindings)
	     (local-set-key "p" (cdr (assoc "p" saved-key-bindings))))
	(and (assoc "n" saved-key-bindings)
	     (local-set-key "n" (cdr (assoc "n" saved-key-bindings))))

	)

      (force-mode-line-update)
      )
    )
  )

(add-to-list 'minor-mode-alist '(qsave-mode "qsave"))

;; advice for using:
;; (add-hook 'xz-after-search-hook 
;;   '(lambda () (qsave-search buffer))
;;   " save output of each xz search on a stack for retrieval")
;; 
;; (add-hook 'xz-init-hook '(lambda () 
;; (define-key xz-mode-map "p" 'previous-xz-search)
;; (define-key xz-mode-map "n" 'next-xz-search)
;; ))
;; 

(provide 'qsave)
