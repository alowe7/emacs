(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/granite/host-init.el,v 1.7 2010-10-02 21:53:57 alowe Exp $")

(require 'ctl-slash)

(setq
 cursor-type (quote (bar . 1))
 cursor-in-non-selected-windows nil
 resize-mini-windows nil
)

(defun file-exists* (f) (and (file-exists-p f) f))

(setq bookmark-default-file
      (or (file-exists* (expand-file-name ".emacs.bmk" (host-config)))
	  (file-exists* (expand-file-name (substitute-in-file-name "$HOME/.emacs.bmk"))))
      )

(setq default-font (cdr (assoc 'font (frame-parameters))))

(setq initial-frame-alist
      (let* ((frame-parameters (frame-parameters))
	     (clone-parameters-list 
	      '((top 0.2) (left 0.2) (width 0.8) (height  0.8) background-mode border-color cursor-color mouse-color background-color foreground-color vertical-scroll-bars internal-border-width border-width font menu-bar-lines)))
	(loop for x in clone-parameters-list
	      collect 
	      (cond ((listp x)
		     (cons (car x) (truncate (* (cdr (assoc (car x) frame-parameters)) (cadr x)))))
		    (t 
		     (cons x (cdr (assoc x frame-parameters))))
		    )
	      )
	)
      default-frame-alist  initial-frame-alist)

(display-time)

(require 'gnuserv)

(setq grep-command "grep -nH -i -e ")

(add-to-load-path "." t)

(setq bookmark-default-file