(put 'auto 'rcsid
 "$Id$")

(defun looking-at* (regexp)
  (save-excursion (goto-char (point-min)) (looking-at regexp))
  )

(defvar *auto-mode-alist* nil "alist of (regexp . mode) where if file begins with with regexp, automatically enter mode
used by post-load hooks to add mode specific peekpatterns")

(defun auto-auto-mode ()
  "when a member of  `find-file-hooks' this function provides an alternative way to derive an auto mode.
for example, by directory, or maybe peeking."

  ; but if only a customized major-mode hasn't already been selected
  (if (eq major-mode 'fundamental-mode)
      (loop for x in  *auto-mode-alist* when (and (listp x) (looking-at*  (car x))) return (funcall (cdr x)))

    )
  )

(provide 'auto)