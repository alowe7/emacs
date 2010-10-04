(put 'perlhelp 'rcsid 
 "$Id$")

(load "/d/perl5/docs/perl-oblist" t t)

(defvar perl-docfile "/d/perl5/docs/perl-builtins")

;(defvar perl-doc-mode-map (copy-keymap view-mode-map))

(defun get-perl-docfile ()
  (or (get-file-buffer perl-docfile)
      (let ((b (find-file-noselect perl-docfile)))
	(save-excursion
	  (set-buffer b)
  ;					(use-local-map perl-doc-mode-map)
  ;					(setq buffer-read-only t)
	  (view-mode)
	  b)
	)
      )
  )

(defun try-perl-oblist (s p d)
  (try-completion 
   (if (<= (length s) 1) (indicated-word) s)
   perl-oblist
   )
  )

(defun help-for-perl (s) 
  (interactive 
   (list
    (completing-read  "perl topic: "
		      perl-oblist
		      nil t (indicated-word))))
  (pop-to-buffer (get-perl-docfile))
  (goto-char (cadr (assoc s perl-oblist)))
  )


(global-set-key "" 'help-for-perl)

(defun pc (cmd) (interactive "sperl command: ")
  (message (eval-process "perl" "-e" (format "\"%s\"" cmd))))

(global-set-key "à" 'pc)


(defun findref (thing)
  ""
  (interactive "sthing: ")
  (grep
   (concat thing " " 
	   (perl-command "enumerate-scripts" "-t" "perl")
	   )
   )
  )
