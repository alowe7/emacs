(put 'roll 'rcsid 
 "$Id: roll.el,v 1.4 2000-10-03 16:50:29 cvs Exp $")
(provide 'roll)
(require 'cl)

(defun roll-search (a pat displayfn i)
  (position pat a 
	    :test 
	    '(lambda (a b) (string-match a (if displayfn (funcall displayfn b) b)))
	    :start
	    (or i 0)
	    ))


(defvar roll-nav-map ()
  "a-list of named  keys to functions.
this might make it easier to adjust navigation through the list by redefining nav-map."
  )

(setq roll-nav-map '(
		     (back 
		      ?p ? ?)
		     (delete
		      ?d)
		     (help
		      ??)
		     (search
		      ?/)
		     (quit
		      ?q)
		     (next
		      ? )
		     )

      )

(defun roll-nav (key fn)
  (member key (cdr (assoc fn roll-nav-map))))

(defun roll-dispatch (key dispatch-map a i)
  (let ((fn (assoc key dispatch-map)))
    (and fn (cadr fn) (apply (cadr fn) (list a i)))
    fn
    )
  )

; (describe-key (vector (roll-nav (y-or-n-q-p "" "p?? ") 'next)))

 
(defun roll-list (l  &optional displayfn deletefn selectfn dispatch donefn)
  "rolls elements in list L, using DISPATCH list.

optional DISPATCH is an a-list: 
	((char fn) ...)

each association dispatches a keyboard character to a function.  if
the key is pressed, the function of one arg is applied to the
subject element of l

calling DISPLAYFN to display the element (returns a string)
	if DISPLAYFN is nil, then l is assumed to be a list of strings, and the element is simply displayed
calling DELETEFN to delete an element
	if DELETEFN is nil, then deleting from l has no side effects
calling SELECTFN to choose one
	if SELECTFN is nil, then roll-list simply returns the selected value
"

  (let* ((a (apply 'vector l))
	 (len (length a))
	 (i 0)
	 (last-pat "")
	 (b (catch 'done
	      (while (> len 0)
		(if (< i 0) (setq i (1- len)))
		(let* ((bb (aref a i))
		       (name (if displayfn (funcall displayfn bb) bb))
		       (v (y-or-n-q-p ; name can have formatting characters in it
			   (replace-in-string "%" "%%" name) 
			   (concat "dp/\C-m ?"
				   (apply 'vector (loop for x in dispatch collect (car x))))
			   )))

		  (cond 

		   ((roll-nav v 'search)
		    (let* ((p (read-string (format "search for (%s): " last-pat)))
			   (pat (if (< (length p) 1) last-pat p))
			   (start (if (< (length p) 1) (1+ i) 0))
			   (next (roll-search a pat displayfn start)))
		      (if next (setq i next
				     last-pat pat)
			(message "%s not found" pat)
			(sit-for 2))))

		   ((roll-nav v 'help)
		    (progn
		      (message "roll-buffer: RET: goto; BS,p: back; SPACE,n: forward; DEL,d: delete; ?: help; q: quit")
		      (read-char)
		      (setq i (1- i))
		      ))

		   ((roll-nav v 'delete)
		    (if deletefn 
			(funcall deletefn l bb))
		    (setq a (apply 'vector l)
			  len (length a)
			  i (1- i))
		    )

		   ((roll-nav v 'back) 
		    (setq i (1- i)))

  ; check for dispatch functions
		   ((and dispatch (roll-dispatch v dispatch a i))
		    nil)

  ; all other keys are handled here
		   ((and v (not (roll-nav v 'next)))
		    (throw 'done (and (not (roll-nav v 'quit)) bb)))

		   (t (setq i (1+ i))))
		  )
								
		(if (>= i len) (setq i 0))
		)))
	 ret)
    (if b (setq ret (if selectfn (funcall selectfn b) b)))

  ; in case a changed, allow it to restore some global state
    (if donefn (funcall donefn a))

    ret
    )
  )


(defvar roll-mode nil)

(defun kill-buffer-1 (l b)
  (kill-buffer b)
  (delete* b l)
  )

(defun roll-buffer-mode (&optional m) 
  (interactive 
   (list
    (intern (completing-read "mode: " (mapcar '(lambda (x) 
						 (cons
						  (format "%s" x) x))
					      (atoms-like "-mode"))))))

  (roll-list (list-mode-buffers (or (string* m) major-mode)) 'buffer-name 'kill-buffer-1 'switch-to-buffer)
  )

(defun roll-buffer-like () 
" roll buffers with mode like current buffer"
  (interactive) 

  (roll-list (list-mode-buffers major-mode) 'buffer-name 'kill-buffer-1 'switch-to-buffer)
  )

(defun roll-buffer-list (&optional l) (interactive)
  (roll-list (or l (get-real-buffer-list nil)) 'buffer-name 'kill-buffer-1 'switch-to-buffer)
  )

(defun roll-buffer-list-1 (mode) 
  "like roll-buffer-list, but only list buffers in mode"
  (interactive (list 
  ; complete with any symbol that ends in "-mode"
		(complete* "list buffers in mode (%s): " "-mode$" (or roll-mode major-mode))
		))
  (roll-list
   (collect-buffers
    (cond
     ((and (stringp mode) (> (length mode) 0)) 
      (intern mode))
     ((or (stringp mode) (not mode) roll-mode) roll-mode)
     (t (setq roll-mode major-mode)))
    )
   'buffer-name 'kill-buffer 'switch-to-buffer)
  )

(defun buffer-list-no-files ()
  (loop for x being the buffers
	when (not (progn (set-buffer x) (buffer-file-name)))
	collect (buffer-name)))

(defun roll-buffers-no-files () (interactive)
(roll-list (buffer-list-no-files) nil 'kill-buffer-1 'switch-to-buffer))


