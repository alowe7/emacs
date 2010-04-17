(put 'config-lib 'rcsid
 "$Id: config-lib.el,v 1.1 2010-04-17 18:51:05 alowe Exp $")

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

; xxx obsolete?
(defun host-config () 
  "find host specific config directory"
  (interactive)
  (let ((d 
	 (loop for x in load-path thereis (and (string-match "/hosts/" x) x))))
    (if (interactive-p)
	(if (file-name-directory d) (dired d) (message (format "directory %s doesn't exist" d)))
      d)
    )
  )

(defun ws-config () 
  "find os specific config directory"
  (interactive)
  (let* ((window-system-name (symbol-name window-system))
	(d 
	 (loop for x in load-path thereis (and (string-match (concat "/os/" window-system-name) x) x))))
    (if (interactive-p)
	(if (file-name-directory d) (dired d) (message (format "directory %s doesn't exist" d)))
      d)
    )
  )

(defun os-config () 
  "find os specific config directory"
  (interactive)
  (let* ((uname (uname))
	 (d 
	 (loop for x in load-path thereis (and (string-match (concat "/os/" uname) x) x))))
    (if (interactive-p)
	(if (file-name-directory d) (dired d) (message (format "directory %s doesn't exist" d)))
      d)
    )
  )

(defun host-init ()
  "shortcut for `find-config-file' \"host-init\""
  (interactive)

  (let ((fn (locate-config-file "host-init")))
    (if current-prefix-arg (dired (file-name-directory fn))
      (find-config-file "host-init")
      )
    )
  )

(defun emacs-version-init ()
  "shortcut for `find-config-file' \"EmacsXX\" where XX=`emacs-major-version'"
  (interactive)
  (let ((emacs-major-version-init-file-name (format  "Emacs%d" emacs-major-version)))
    (find-config-file emacs-major-version-init-file-name)
    )
  )

(defun os-init ()
  "shortcut for `find-config-file' \"os-init\""
  (interactive)
  (find-config-file "os-init")
  )

(defun window-system-init ()
  "shortcut for `find-config-file' \"window-system-init\""
  (interactive)
  (find-config-file "window-system-init")
  )