(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/slate/host-init.el,v 1.3 2007-11-24 21:54:07 slate Exp $")

; enoch..tombstone..slate

(require 'post-dired)

(require 'ctl-slash)
(require 'ctl-ret)

(require 'long-comment)
(require 'whack-font)

(require 'cat-utils)
; (require 'gnuserv)
(setq display-time-day-and-date t)
(display-time)

(scroll-bar-mode -1)

(and (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(and (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(load-library "bookmark")
(load-library "post-bookmark")

(setq x-select-enable-clipboard t)


(global-set-key (vector ?) 'undo)
(global-set-key (vector ?\C-c ?\C-j) 'font-lock-fontify-buffer)

(setq grep-command "grep -n -i -e ")
(setq jit-lock-stealth-time 1)

(defun lframe ()
  (interactive)
  (let* ((default-frame-alist default-frame-alist))

    (loop for x in 
	  '(
	    (width . 119)
	    (height . 29)
	    (top . 62)
	    (left . 32)
	    (font . "-*-lucida-medium-r-normal-*-14-140-*-*-*-*-iso8859-1"))
	  do (add-association x 'default-frame-alist t)
	  )
    (call-interactively 'switch-to-buffer-other-frame)
    )
  )

(add-to-list 'load-path "/u/z/el")
(load-library "mpg123")


(defun nd (&optional dir)
  (interactive)
  (let* (
	 (dir (or dir default-directory))
	 (pname (concat "*nautilus " dir "*"))
	 (p (loop for p in (process-list) when (string= pname (process-name p)) return p)))

    (if p
	(message (format "process %s already exists" pname))
      (start-process pname nil "nautilus" dir)
      )
    )
  )
(global-set-key (vector 'f12) 'nd)
(require 'lazy-lock)

(post-wrap "dired")
(post-wrap "compile")

(define-key ctl-RET-map (vector ?\C- ) 'zz)

; uncompress isn't as obsolete as someone thinks.
(autoload 'uncompress-while-visiting "uncompress")

(define-key ctl-RET-map "" 'flush-lines)
(define-key ctl-RET-map "" 'keep-lines)

; (add-to-list 'load-path "/usr/share/emacs/22.1/lisp")