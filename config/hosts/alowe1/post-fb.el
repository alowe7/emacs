(put 'post-fb 'rcsid
 "$Id$")

; some fb toys
(require 'compile)

(defun fwf (pat)
  "find within files -- search for file matching PAT in file list produced by `ff'"

  (interactive "sfind files: ")

  ; assert: within a fb buffer
  (assert (and
	   (string= (buffer-name (current-buffer)) *fastfind-buffer*)
	   (eq major-mode (quote fb-mode))))

  (toggle-read-only -1)

  (shell-command-on-region (point-min) (point-max) (concat "grep " pat) *fastfind-buffer* t)

  (setq *find-file-query*
	(setq mode-line-buffer-identification 
	      pat))

  (beginning-of-buffer)

  (set-buffer-modified-p nil)
  (toggle-read-only 1)

  (run-hooks 'after-find-file-hook)

  )