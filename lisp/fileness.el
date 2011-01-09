(put 'fileness 'rcsid 
 "$Id$")

(defvar *no-fileness-modes* '(java-mode))
(defvar *file-name-chars* '(?/ ?: ?.))
(defvar *file-name-chars-prior-syntax* nil)

(defun wordness ()
  "treat file descriptors as words in their entirety
with optional ARG, toggles current behavior.  see `fileness'
"
  (interactive)
  (if (member major-mode *no-fileness-modes*)
  ; this messes up fontification, apparently undoably.
      (progn
	(message "you probably mean minibuffer-wordness")
	(minibuffer-wordness))

    (loop for x in *file-name-chars* do
	  (let ((c (assoc x *file-name-chars-prior-syntax*)))
	    (and c (modify-syntax-entry x (format "%s" c) (syntax-table)))
	    ))
    )
  )

(defun fileness ()
  "treat individual elements of file descriptors as words
with optional ARG, toggles current behavior.  see `wordness'
"
  (interactive)
  (if (member major-mode *no-fileness-modes*)
  ; this messes up fontification, apparently undoably.
      (progn
	(message "you probably mean minibuffer-fileness")
	(minibuffer-fileness))
    (loop for x in *file-name-chars* do
	  (add-association (list x (char-syntax x)) '*file-name-chars-prior-syntax*)
	  (modify-syntax-entry x "." (syntax-table))
	  )
    )
  )

(defun minibuffer-fileness () 
  (interactive)
  (with-current-buffer
      (window-buffer (minibuffer-window))
    (fileness))
  )

(defun minibuffer-wordness () 
  (interactive)
  (with-current-buffer
      (window-buffer (minibuffer-window))
    (wordness))
  )

