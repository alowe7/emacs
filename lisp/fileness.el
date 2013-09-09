(put 'fileness 'rcsid 
 "$Id$")

(defvar *no-fileness-modes* '(java-mode))
(defvar *file-name-chars* '(?/ ?: ?.))
(defvar *file-name-chars-prior-syntax* nil)

(defun wordness (&optional arg)
  "treat file descriptors as words in their entirety
with optional ARG, toggles current behavior.  see `fileness'

bug: toggle not implemented
"
  (interactive "P")
  (if (member major-mode *no-fileness-modes*)
  ; this messes up fontification, apparently undoably.
      (progn
	(message "you probably mean minibuffer-wordness")
	(minibuffer-wordness))

    (loop for x in *file-name-chars* do
	  (modify-syntax-entry x c (syntax-table))
	  )
    )
  )

(defun fileness ()
  "treat individual elements of file descriptors as words
with optional ARG, toggles current behavior.  see `wordness'

bug: toggle behavior not implemented
"
  (interactive)

  (if (member major-mode *no-fileness-modes*)
  ; this messes up fontification, apparently undoably.
      (error "fileness not supported in this mode.  did you mean minibuffer-fileness?")

    (loop for x in *file-name-chars* do
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

