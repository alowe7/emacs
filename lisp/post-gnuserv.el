(put 'post-gnuserv 'rcsid 
 "$Id: post-gnuserv.el,v 1.7 2001-09-08 20:50:36 cvs Exp $")

(condition-case x (gnuserv-start) (error nil)) ; if there's a problem don't try to restart.

(require 'advice)

(defadvice server-find-file (after 
			     hook-server-find-file
			     first 
			     nil
			     activate)
  (raise-frame)
  )

; (ad-is-advised 'server-find-file)
; (ad-unadvise 'server-find-file)

(defadvice server-edit (after 
			hook-server-edit
			first 
			nil
			activate)
  (unless server-clients
    (lower-frame))
  )

; (ad-is-advised 'server-edit)
; (ad-unadvise 'server-edit)

(defun gnuserv-stop () 
  (interactive)
  "kill a gnuserv server"
  (if server-process
      (progn
	(server-release-outstanding-buffers)
	(set-process-sentinel server-process nil)
	(condition-case ()
	    (delete-process server-process)
	  (error nil))))
  )

(require 'roll)

(defun roll-server-clients ()
  "roll gnuserv buffers"
  (interactive)
  (let ((l (and (boundp 'server-clients) (loop for x in server-clients collect (cadr x)))))
    (if l
	(roll-buffer-list l)
      (message "no server clients")
      )
    )
  )

;; set default frame for gnuserving
(setq gnuserv-frame
      (caadr (current-frame-configuration)))

;; keep it valid after changes to frame configuration
(defadvice delete-all-other-frames (after 
				    hook-delete-all-other-frames
				    first 
				    nil
				    activate)
  (setq gnuserv-frame 
	(caadr (current-frame-configuration)))
  )

; (ad-is-advised 'delete-all-other-frames)
; (ad-unadvise 'delete-all-other-frames)

(defadvice delete-frame (after 
			 hook-delete-frame
			 first 
			 nil
			 activate)
  (setq gnuserv-frame 
	(caadr (current-frame-configuration)))
  )

