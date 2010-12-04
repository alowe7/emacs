(put 'host-init 'rcsid
     "$Id$")

(require 'ctl-slash)

(setq
 cursor-type (quote (bar . 1))
 cursor-in-non-selected-windows nil
 resize-mini-windows nil
)

(defun file-exists* (f) (and (file-exists-p f) f))

(setq 
 bookmark-default-file
 (expand-file-name ".emacs.bmk" (file-name-directory (locate-config-file "host-init")))
 )

(display-time)

(require 'gnuserv)

(setq grep-command "grep -nH -i -e ")

(add-to-load-path "." t)

(setq 
 bookmark-default-file
 (expand-file-name ".emacs.bmk" (file-name-directory (locate-config-file "host-init")))
 )

(add-to-list 'load-path "/u/emacs-w3m/")
(setq w3m-command "/u/w3m-0.5.2/w3m.exe")

