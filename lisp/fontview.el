(put 'fontview 'rcsid 
 "$Id: fontview.el,v 1.8 2004-08-11 14:55:52 cvs Exp $")
(require 'view)

(defvar fontview-mode-map nil "")
(defvar fontview-mode-syntax-table nil "")
(defvar fontview-mode-hook nil "hook run when viewing font list")

(defun set-indicated-font (&optional face frame)
  (interactive)
  (let ((facep (or face 'default))
	(font (indicated-word)))
					;  (set-face-font 'default font)
    (internal-set-face-1 facep 'font font 3 frame))
  )

(defun fontview-mode (&optional force)
  "enter fontview mode on current buffer, unless already there
if optional arg FORCE is non-nil, enter mode anyway.

runs value of fontview-mode-hook on entry.
see fontview-mode-map keymap & fontview-mode-syntax-table
"
  (interactive)
  (or (and (not force) (eq major-mode 'fontview-mode))
      (progn
	(use-local-map
	 (or fontview-mode-map (prog1
				   (setq fontview-mode-map (copy-keymap view-mode-map)
					 (define-key fontview-mode-map "" 
					   '(lambda () (interactive) (set-indicated-font) (next-line 1)))
					 )
				 )
	     )

	 (set-syntax-table 
	  (or fontview-mode-syntax-table
	      (prog1
		  (setq fontview-mode-syntax-table (make-syntax-table))
		(modify-syntax-entry ?_ "w" fontview-mode-syntax-table)
		(modify-syntax-entry ?, "w" fontview-mode-syntax-table)
		(modify-syntax-entry ?- "w" fontview-mode-syntax-table)
		(modify-syntax-entry ?* "w" fontview-mode-syntax-table)
		(modify-syntax-entry ?  "w" fontview-mode-syntax-table)
		)
	      )
	  )

	 (setq mode-name "Fontview")
	 (setq major-mode 'fontview-mode)
	 (setq mode-line-process nil)
	 (run-hooks 'fontview-mode-hook)
	 )
	)
      )
  )

(defun nt-list-fonts (face)
  (interactive "sface: ")
  (let* ((facep (if (> (length face) 0) face "default"))
	(bname (concat face "-fonts"))
	(fontlist (x-list-fonts "" (intern facep))))
    (zap-buffer bname)
    (dolist (x fontlist)
      (insert (concat x "
"))
      )
    (pop-to-buffer bname)
    (set-buffer-modified-p nil)
    (setq buffer-read-only t)
    (beginning-of-buffer)
    (fontview-mode)
    ))