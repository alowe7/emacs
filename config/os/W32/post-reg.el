(put 'post-reg 'rcsid
 "$Id: post-reg.el,v 1.3 2004-07-27 22:20:26 cvs Exp $")

(defun lsrun (arg) (interactive "P") 
  "show the contents of the windows/currentversion/run key in the machine hive.
with ARG, show the contents of this key from the user hive"
  (if arg
      (lsreg "user" "software/microsoft/windows/currentversion/run")
    (lsreg "machine" "software/microsoft/windows/currentversion/run")
    )
  )


(defun clsid (id) 
  (interactive (list (string* (read-string (format "classid (%s): " (indicated-word "-"))) (indicated-word "-"))))
  "show the class info for the specified classid"

  (lsreg "machine" (format "software/classes/clsid/{%s}" id))

  )

(define-key reg-view-mode-map "n" '(lambda () (interactive) (next-line 1)))
(define-key reg-view-mode-map "u" '(lambda () (interactive) (previous-line 1)))
(define-key reg-view-mode-map "b" '(lambda () (interactive) (reg-previous-query)))
(define-key reg-view-mode-map " " '(lambda () (interactive) (reg-descend)))

(defun get-editor (ext)
  (let ((ext (or (string-match "\\." ext) (concat "." ext)))
	(key (concat "SOFTWARE/Microsoft/Windows/CurrentVersion/Explorer/FileExts/"  ext))
	(hive  "user")
	(value "Application")
	)
    (getvalue hive key value)
    )
  )


(defun set-editor (ext &optional editor)
  "define the windows application editor for the specified filetype
EXT gives the file extension (with or without preceeding \".\")
optional EDITOR defines the editor (default gnuclientw)
"
  (let ((ext (or (string-match "\\." ext) (concat "." ext)))
	(key (concat "SOFTWARE/Microsoft/Windows/CurrentVersion/Explorer/FileExts/"  ext))
	(hive  "user")
	(value "Application")
	(editor (or editor "gnuclientw.exe"))
	)
    (setvalue hive key value editor)
    )
  )

; define gnuclientw as the default editor for these filetypes
(set-editor ".jsp")
(set-editor ".xml")

(defun view-file-type (ext)
  (interactive "sext: ")
  (let ((ext (or (string-match "\\." ext) (concat "." ext)))
	(key (concat "SOFTWARE/Microsoft/Windows/CurrentVersion/Explorer/FileExts/"  ext))
	(hive  "user")
	)
    (lsreg hive key)
    )
  )
; (view-file-type ".html")

