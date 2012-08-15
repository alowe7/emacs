(put 'windows-explorer-helpers 'rcsid
 "$Id$")

(require 'directories)

(defvar last-dosexec "")
(defun dosexec (cmd) 
  "run as a dos parented program"
  (interactive (list (read-string (format "scommand (%s): " last-dosexec))))
  (let ((f (if (eq major-mode (quote dired-mode))
	       (dired-get-filename)
	     (read-file-name "input file: ")))
	(cmd (if 
		 (and (<= (length cmd) 0)
		      (> (length last-dosexec) 0))
		 last-dosexec cmd)))
    (setq last-dosexec cmd)
    (start-process (format "dosexec %s" cmd) nil "cmd" "/c" cmd f))
  )

(defvar *pf* "/program files" "location of windows style program files")
(defvar *ulb* "/usr/local/lib" "location of unix style installed programs")

(defun find-file-in-dir (dir)
  (expand-file-name
   (concat dir "/"
	   (completing-read "dir: " (mapcar 'list (get-directory-files dir)) nil t)
	   ))
  )

(defun pf  (dir)
  "dired in `*pf*'"
  (interactive (list 
		(find-file-in-dir *pf*)))
  (dired dir)
  )

(defun ulb  (dir)
  "dired in `*ulb*'"
  (interactive (list 
		(find-file-in-dir *ulb*)))
  (dired dir)
  )

(defun md-get-arg (&optional arg)
  "."
  )

(defun md (&optional arg) 
  (interactive "P") 
  (explore (md-get-arg arg))
  )

; todo: (alldrives) returns enumeration of drives in use

(defun vp (&optional user)
  "visit profile directory for USER.  default is current user"
  (interactive)
  (dired  (expand-file-name
	   (concat *systemroot* "/profiles/" (or user *username*) "/Personal/" nil)))

  )

(/*
 (defun browse-path (arg) 
   "pringle path in a browser buffer"
   (interactive "P")
   (let ((temp-buffer-show-function '(lambda (buf)
				       (switch-to-buffer buf)
				       (fb-mode)))
	 (l (if arg 
		(eval (read-variable "path var: "))
	      (catpath "PATH" (if (eq window-system 'win32) semicolon)))))

     (with-output-to-temp-buffer "*Path*"
       (mapcar '(lambda (x) (princ (expand-file-name x)) (princ "\n")) l)
       )
     )
   )
 )

(defun control-panel (c) 
  "run control panel applets"
  (interactive
   (list
    (completing-read
     "?" 
     (mapcar
      '(lambda (x)
	 (list
	  (file-name-sans-extension x)))
      (directory-files (expand-file-name (concat *systemroot* "/system32")) nil "cpl$")
      )
     )))

  (let ((p (get-process "cpl")))
    (and p (kill-process p))
    (start-process "cpl" nil "control" (concat c ".cpl")
		   )
    )
  )
