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
(loop for x in '("os-init" "host-init") ; more tbd?
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

(defun emacs-version-init ()
  "shortcut for `find-config-file' \"EmacsXX\" where XX=`emacs-major-version'"
  (interactive)
  (let ((emacs-major-version-init-file-name (format  "Emacs%d" emacs-major-version)))
    (find-config-file emacs-major-version-init-file-name)
    )
  )


(defun host-config ()
  (interactive)
  "find shell config dir"
  (let ((dir (expand-file-name "bin" (expand-file-name (hostname) "~/config/hosts"))))
    (if (file-directory-p dir) (dired dir) (message "%s does not exist" dir))
    )
  )
; (call-interactively 'host-config)
