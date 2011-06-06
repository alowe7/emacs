(put 'post-locate 'rcsid
 "$Id$")

(chain-parent-file t)

(defun locate-explore-directory ()
  (interactive)
  (explore (file-name-directory (locate-get-dirname)))
  )

(define-key locate-mode-map (vector 'f12) 'locate-explore-directory)

(defvar  locate-options '("--ignore-case"))
(defun my-locate-default-make-command-line (search-string)
  `(,locate-command ,@locate-options ,search-string))
(setq locate-make-command-line 'my-locate-default-make-command-line)
; (funcall locate-make-command-line "foo")
