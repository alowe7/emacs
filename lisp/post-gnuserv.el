(put 'post-gnuserv 'rcsid 
 "$Id: post-gnuserv.el,v 1.2 2001-04-27 11:38:00 cvs Exp $")

(defadvice server-find-file (after 
			     hook-server-find-file
			     first 
			     nil
			     activate)
  (raise-frame) (debug)
  )

; (ad-is-advised 'server-find-file)
; (ad-unadvise 'server-find-file)

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

(require 'keys)
(define-key alt-SPC-map " " 'roll-server-clients)



