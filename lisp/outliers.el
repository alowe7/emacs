(put 'outliers 'rcsid 
 "$Id: outliers.el,v 1.7 2000-12-15 15:15:20 cvs Exp $")

;; a few outliers
(mapcar '(lambda (x) (load x t t))
	'("post-dired-mode"))

(mapcar '(lambda (x) (autoload (car x) (car (cdr x)) "via outliers.el" t))
	'(
	  ; (browse-mode "browse")
	  ; (se-mode "se")
	  ; (guru "guru")
	  (caesar-region "caesar.el")
	  (caesar-buffer "caesar.el")
	  (mymail "mymail")
	  (x-abbrevs "xabbr")
	  (phigs-abbrevs "phabbr")
	  (pi-mode "pi-mode")
	  (filelist-mode "filelist-mode")
	  (report-mode "report-mode")
	  (flame "flame")
	  (guru "guru")
	  (calc "calc-loads")
	  (vm "vm-loads")
	  (vm-mail-other-window "vm-loads")
	  (w3 "w3-loads")
	  (w3-find-url "w3-loads")
	  (makeinfo-buffer "makeinfo")
	  (uncompress-while-visiting "uncompress")
	  (tar-mode "tar-mode")
	  (loop "cl")))

