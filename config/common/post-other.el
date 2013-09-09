(put 'post-other 'rcsid
 "$Id$")

(defadvice rfo (around 
			   hook-rfo
			   first activate)
  ""

(let ((p (point)))
  ad-do-it
  (goto-char (min p (point-max))))
)


(defun cd-other-window ()
  " change the current window's current directory to that of other window"
  (interactive)
  (save-window-excursion
    (other-window 1)
    (let ((z default-directory))
      (other-window -1)
      (cd z))))

