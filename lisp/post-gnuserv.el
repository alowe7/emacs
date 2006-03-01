(put 'post-gnuserv 'rcsid 
 "$Id: post-gnuserv.el,v 1.10 2006-03-01 02:52:43 tombstone Exp $")

(condition-case x (gnuserv-start) 
  (error 
  ; if there's a problem try to force restart.
   (condition-case y
       (gnuserv-start t) 
  ; if that doesn't work, forget it.
     (progn 
       (message "can't start server process")
       (debug)
       nil))))

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

; override this function as its broken
;; (defun server-process-filter (proc string)
;;   "Process client gnuserv requests to execute Emacs commands."
;; 
;;   (setq server-string (concat server-string string))
;;   (if (string-match "\^D$" server-string) ; requests end with ctrl-D
;;       (if (string-match "^[0-9]+" server-string) ; client request id
;; 	(progn
;; 	  (server-log server-string)
;; 	  (let ((header (read-from-string server-string)))
;; 	    (setq current-client (car header))
;; 
;; 	    (condition-case oops
;; 		(eval (car (read-from-string server-string 
;; 					     (cdr header))))
;; 	      (error (setq server-string "")
;; 		     (server-write-to-client current-client oops)
;; 		     (setq current-client nil)
;; 		     (signal (car oops) (cdr oops)))
;; 	      (quit (setq server-string "")
;; 		    (server-write-to-client current-client oops)
;; 		    (setq current-client nil)
;; 		    (signal 'quit nil)))
;; 	    (setq server-string "")))
;; 	(progn				;error string from server
;; 	  (server-process-display-error server-string)
;; 	  (setq server-string "")))))

(setq *gnuserv-buffer-lim* 255)

(defun server-write-to-client (client form)
  "Write the given form to the given client via the server process."

  (if (and client
	   (eq (process-status server-process) 'run))
      (let* ((result (format "%s" form))
	     (s      (format "%s/%d:%s\n" client (length result) result)))
  ; logic to bunch up server output is broken.
  ;	(debug)
	(while (> (length s)  *gnuserv-buffer-lim*)
	  (setq s1 (substring s 0  *gnuserv-buffer-lim*)
		s (substring s  *gnuserv-buffer-lim*))
	  (process-send-string server-process s1))
	(process-send-string server-process s)

	(server-log s))))

; (length (format "%s" load-path))