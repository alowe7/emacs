(put 'post-worlds 'rcsid
 "$Id: post-worlds.el,v 1.5 2003-12-09 17:23:18 cvs Exp $")

(chain-parent-file t)

(defvar *tw-ico-file* (w32-canonify "/x/tw/util/tw.ico"))

(defvar *tw-create-desktop-shortcut* nil)
(defvar *tw-create-quicklaunch* nil)
(defvar *tw-create-w32-cmd* nil)

(add-hook 'world-post-change-hook
	  (lambda () 
  ; from the dos command line /w will always take you there
	    (if *tw-create-w32-cmd*
		(write-region 
		 (concat "@cd " (w32-canonify (expand-file-name (fw))))
		 nil 
		 (expand-file-name "/w.cmd")
		 )
	      )
  ; from the desktop -- only do this for worlds you actually enter
	    (if *tw-create-desktop-shortcut*
		(shell-command 
		 (format "shortcut -f -t \"%s\" -n \"%s/%s\" %s " 
			 (w32-canonify (fw) t) 
			 (w32-canonify (concat user-profile "/desktop")) 
			 (current-world)
			 (if (-f *tw-ico-file*)
			     (format "-i \"%s\"" *tw-ico-file*)
			   (format "-i \"%s\" -x \"%d\""
				   (w32-canonify (substitute-in-file-name "$SystemRoot/SYSTEM32/shell32.dll"))
				   13))
			 )
		 )
	      )

	    (if *tw-create-quicklaunch*
  ; create a quicklaunch to the dir
		(shell-command 
		 (format "shortcut -f -t \"%s\" -n \"%s/%s\"" 
			 (w32-canonify (fw) t)
			 quicklaunch
			 (current-world)
			 (if (-f *tw-ico-file*)
			     (format "-i \"%s\"" *tw-ico-file*)
			   (format "-i \"%s\" -x \"%d\""
				   (w32-canonify (substitute-in-file-name "$SystemRoot/SYSTEM32/shell32.dll"))
				   13))
			 )
		 )
	      )
	    )
	  )

;; world helpers ;;
(defun ewn  (&optional w go sub)
  "expore file in W named F"
  (interactive "P")
  (wn w go 'explore))

(defun ewd  (&optional w go sub)
  (interactive "P")
  (wd w 'explore))
