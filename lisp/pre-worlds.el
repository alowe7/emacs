(defconst rcs-id "$Id: pre-worlds.el,v 1.4 2000-07-31 15:00:57 cvs Exp $")
(require 'reg)
(require 'world-advice)

(defvar *world-goto-lastdir* t "if set, jump to (lastdir) on world entry")

; this gets called after entering
(add-hook
 'world-post-change-hook
 (function (lambda ()
	     (and *world-goto-lastdir* (lastdir))
	     (lastworld t)
;	     (world-build-mail-aliases)
	     (name-frame (current-world))

	     (call-process "perl" nil 0 nil
			   ($ "$PBASE/bin/world-update-registry")
			   (w32-canonify (find-world-directory (current-world)))))
	   )) 


; this gets called before leaving
(add-hook 'world-pre-change-hook
	  '(lambda nil (lastworld t)))

(if (and (boundp 'master-log-file)
	 (file-exists-p master-log-file))
    (add-hook 'kill-emacs-hook 
	      '(lambda nil
		 (log-entry "leaving %s" (getenv "WORLD")))))

(add-hook 'world-post-change-hook
	  '(lambda nil
	     (setq world-stack (remove* (current-world) world-stack :test 'string-equal))))

(add-hook 'world-init-hook 
	  (function
	   (lambda () (lastworld)
	     (add-hook 'after-save-hook 'world-file-save-hook))))

(defun world-build-mail-aliases () (interactive)
  (let* ((wd (getenv "W"))
	 (waliases (concat wd "/.aliases")))
    (and (file-exists-p waliases)
	 (fboundp 'build-mail-aliases)
	 (build-mail-aliases waliases)
	 ))
  )

