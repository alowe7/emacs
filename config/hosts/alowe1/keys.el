(put 'keys 'rcsid
 "$Id$")

(chain-parent-file t)

(require 'ctl-slash)


(define-key ctl-/-map "\C-l" 'xl)

; define ctl-/ ctl-/ as another map

(if (not (fboundp 'ctl-/-ctl-/-prefix)) 
    (define-prefix-command 'ctl-/-ctl-/-prefix)) ;; don't wipe out map if it already exists

(define-key ctl-/-map (vector (ctl ?/)) 'ctl-/-ctl-/-prefix)

(setq ctl-/-ctl-/-map (symbol-function  'ctl-/-ctl-/-prefix))

(define-key ctl-/-ctl-/-map "\C-l" 'xll)

(require 'ctl-ret)

(define-key ctl-RET-map "\`" 'diff-backup)
(defun visit-backup () (interactive)
  (let* ((f (buffer-file-name))
	(b (and f (make-backup-file-name f))))
    (if (file-exists-p b)
	(find-file b)
      (message (format "no backup file for: %s" f))))
  )

(define-key ctl-RET-map "~" 'visit-backup)