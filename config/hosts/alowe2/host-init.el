(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/alowe2/host-init.el,v 1.13 2001-09-02 00:25:22 cvs Exp $")

(setq default-frame-alist
      '((top + -4)
	(left + -4)
	(width . 128)
	(height . 55)
	(background-mode . light)
	(cursor-type . box)
	(border-color . "black")
	(cursor-color . "black")
	(mouse-color . "black")
	(background-color . "white")
	(foreground-color . "black")
	(vertical-scroll-bars)
	(internal-border-width . 0)
	(border-width . 2)
	(font . "-*-lucida console-normal-r-*-*-17-nil-*-*-*-*-*-*-")
	(menu-bar-lines . 0))
      )

(setq initial-frame-alist default-frame-alist)

(if (file-directory-p "d:/x/elisp")
    (load "d:/x/elisp/.autoloads" t t t)
  )

(let ((d "d:/x/elisp/play"))
      (mapcar '(lambda (x) (load (concat d "/" x) t t)) 
	      '("kill" "buff" "msvc" "syntax" "key" "show")))

;(get-directory-files d t "\.el$")

(add-hook 'after-init-hook '(lambda () 
			      (defadvice info (before 
					       hook-info
					       first 
					       activate)
				(cd "/")
				)))

(add-hook 'people-load-hook (lambda () 
			    (setq *people-database*
				  (mapcar 'expand-file-name
					  (list (concat (fw "broadjump") "/n/people")
						"~/n/people")))))


(display-time)

(require 'xz-loads)
(setq *xz-show-status* nil)
(setq *xz-squish* 4)

(require 'gnuserv)

(require 'worlds)
(require 'world-advice)
(lastworld)
