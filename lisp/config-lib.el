(put 'config-lib 'rcsid
 "$Id$")

; would rather avoid this during init...
; ... so moved these funcs to lazy autoload

(require 'uname)

(defun locate-config-file (fn)
  "find CONFIG along load-path.
searches first for config unadorned, then with extension .el
returns full path name.
"
  (let ((afn (loop for a in load-path
		   thereis (let ((afn (format "%s/%s" a fn)))
			     (or (and (file-exists-p afn) afn)
				 (and (file-exists-p (setq afn (concat afn ".el"))) afn))
			     )
		   )))
    afn)
  )
; (locate-config-file "host-init")
; (locate-config-file "os-init")

(defun find-config-file (fn)
  "visit CONFIG along load-path, if it exists.
see `locate-config-file'"

  (interactive "sconfig file: ")
  (let ((afn (locate-config-file fn)))
    (if afn (find-file afn) 
      (message "%s not found along load-path" fn)
      )
    )
  )

;;; autoload os-init
; autoload host-init
(loop for x in '("os-init" "host-init" "common-init") ; more tbd?
      do
      (eval
       `(defun ,(intern x) ()
	  ,(format "shortcut for `find-config-file' \"%s\"
with optional prefix arg, dired containing directory
" x)
	  (interactive)

	  (let* ((config  ,x)
		 (fn (locate-config-file config)))
	    (if (null fn)
		(message (format "config %s not found along load-path." fn))
	      (if current-prefix-arg (dired (file-name-directory fn))
		(find-file fn) 
		)
	      )
	    )
	  )
       )
      )
; (os-init)
; (host-init)
; (common-init)

(defun emacs-version-init ()
  "shortcut for `find-config-file' \"EmacsXX\" where XX=`emacs-major-version'"
  (interactive)
  (let ((emacs-major-version-init-file-name (format  "Emacs%d" emacs-major-version)))
    (find-config-file emacs-major-version-init-file-name)
    )
  )

(defun hostrc ()
  (interactive)
  "find host specific shell rc"

  (let ((hostname (hostname)))
    (cond
     ((null hostname)
      (when (called-interactively-p 'any) (message "hostname not defined")))
     (t
      (let ((dir (expand-file-name hostname "~/config/hosts")))
	(cond 
	 ((not (file-directory-p dir))
	  (when (called-interactively-p 'any) (message "%s not found" dir)))
	 (t
	  (let ((rcfile (expand-file-name ".bashrc" dir)))
	    (cond
	     ((not (file-exists-p rcfile))
	      (when
		  (called-interactively-p 'any) (message "%s not found" rcfile)))
	     (t
	      (find-file rcfile))
	     )
	    )
	  )
	 )
	)
      )
     )
    )
  )
; (call-interactively 'hostrc)


(defun host-config ()
  (interactive)
  "find shell config dir"
  (let ((dir (expand-file-name (hostname) "~/config/hosts")))
    (cond
     ((and (interactive-p) (file-directory-p dir))
      (dired dir))
     ((file-directory-p dir) 
      dir)
     ((interactive-p)
      (message "%s does not exist" dir)))
    )
  )
; (call-interactively 'host-config)
; (host-config)

(defun host-bin ()
  (interactive)
  "find shell bin dir"
  (let* ((host-config (host-config))
	 (dir (and host-config (expand-file-name "bin" host-config))))
    (cond
     ((and (interactive-p) (file-directory-p dir))
      (dired dir))
     ((file-directory-p dir) 
      dir)
     ((interactive-p)
      (message "%s does not exist" dir)))
    )
  )
; (call-interactively 'host-bin)
; (host-bin)
