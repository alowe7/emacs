(put 'post-gnuserv 'rcsid 
 "$Id: post-gnuserv.el,v 1.6 2001-08-24 20:16:00 cvs Exp $")

(condition-case x (gnuserv-start) (error nil)) ; if there's a problem don't try to restart.

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

