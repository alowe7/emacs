; automatically generated for the most part.  see ../Makefile
(load "../auto-autoloads" t t t )

;; a few outliers

(mapcar '(lambda (x) (autoload (car x) (car (cdr x)) "via autoload.el" t))
	'((browse-mode "browse")
	  (se-mode "se")
	  (guru "guru")
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
	  (calc "calc")
	  (calc "calc-loads")
	  (vm "vm-loads")
	  (vm-mail-other-window "vm-loads")
	  (w3 "w3-loads")
	  (w3-find-url "w3-loads")
	  (makeinfo-buffer "makeinfo")
	  (uncompress-while-visiting "uncompress")
	  (tar-mode "tar-mode")
	  (loop "cl")))

;;
;; ispell4:
;;
(autoload 'ispell-word "ispell4" 
  "Check spelling of word at or before point" t)
(autoload 'ispell-complete-word "ispell4" 
  "Complete word at or before point" t)
(autoload 'ispell-region "ispell4" 
  "Check spelling of every word in the region" t)
(autoload 'ispell-buffer "ispell4" 
  "Check spelling of every word in the buffer" t)
(setq ispell-command "/usr/local/lib/ispell4/exe/ispell.exe"
      ispell-look-dictionary "/usr/local/lib/ispell4/ispell.wor"
      ispell-look-command "/usr/local/lib/ispell4/exe/look.exe"
      ispell-command-options (list "-d" "/usr/local/lib/ispell4/ispell.dic")
      )
