(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/alowe2/host-init.el,v 1.14 2001-10-25 21:27:22 cvs Exp $")

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

(add-to-list 'load-path "/x/elisp")

(mapcar 
 '(lambda (x) (load x t t)) 
 '("kill" "buff" "msvc" "syntax" "key" "show"))

(add-hook 'xz-load-hook 
	  '(lambda ()
	     (mapcar
	      '(lambda (x) (load x t t)) 
		     '("xz-compound" "xz-fancy-keys" "xz-constraints"))))



;(get-directory-files d t "\.el$")

(add-hook 'after-init-hook '(lambda () 
			      (defadvice info (before 
					       hook-info
					       first 
					       activate)
				(cd "/")
				)))

(add-hook 'people-load-hook (lambda () ; (require 'worlds)
			      (setq *people-database*
				    (list (xwf "n/people" "broadjump")
					  "~/n/people"))))

(setq *shell-track-worlds* t)

(display-time)

(require 'xz-loads)
(setq *xz-show-status* nil)
(setq *xz-squish* 4)

(require 'gnuserv)

(setenv "XDBHOST" "kim.alowe.com")
(setenv "XDB" "x")
(setenv "XDBUSER" "a")

(require 'worlds)
(require 'world-advice)

(lastworld)


;; these need to be here until host-init moves prior to default.el  
;; see before-init-hook.

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

(mount-hook-file-commands)
