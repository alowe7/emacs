(put 'post-worlds 'rcsid
 "$Id: post-worlds.el,v 1.1 2003-07-18 14:51:25 cvs Exp $")

(chain-parent-file t)

(defvar *tw-ico-file* (w32-canonify "/x/tw/util/tw.ico"))

(add-hook 'world-post-change-hook
	  (lambda () 
  ; from the dos command line /w will always take you there
	    (write-region 
	     (concat "cd " (w32-canonify (expand-file-name (fw)))) nil (expand-file-name "/w.cmd"))
  ; from the desktop -- only do this for worlds you actually enter

	    (shell-command 
	     (format "shortcut -f -t \"%s\" -n \"%s/%s\" %s " 
		     (w32-canonify (fw) t) 
		     (w32-canonify (concat userprofile "/desktop"))
		     (current-world)
		     (if (-f *tw-ico-file*)
			 (format "-i \"%s\"" *tw-ico-file*)
		       (format "-i \"%s\" -x \"%d\""
			       (w32-canonify (substitute-in-file-name "$SystemRoot/SYSTEM32/shell32.dll"))
			       13))
		     )
	     )

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

;; world helpers ;;
(defun ewn  (&optional w go sub)
  "expore file in W named F"
  (interactive "P")
  (wn w go 'explore))

(defun ewd  (&optional w go sub)
  (interactive "P")
  (wd w 'explore))
