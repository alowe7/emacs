(put 'Emacs21 'rcsid
 "$Id: Emacs21.el,v 1.8 2004-01-14 18:29:41 cvs Exp $")

(define-key help-map "a" 'apropos)

; got used to using space for completion...
(define-key minibuffer-local-completion-map " " 'minibuffer-complete)
(define-key minibuffer-local-completion-map "	" 'minibuffer-complete-word)

; silence the dinger
(setq ring-bell-function '(lambda () nil))

(defvar default-fontspec-format  "-*-%s-%s-r-*-*-%s-%s-*-*-*-*-*-*-")
(defvar default-weight "*")

(defun window-system-faces ()
  (and (boundp 'window-system)
       (cond ((eq window-system 'w32)
  ;	      (setq font-height 104)
  ;	      (set-face-attribute 'default nil :family "arial" :height font-height :weight 'ultra-light))
	      (setq
	       default-font-family "verdana"
	       default-style "normal"
	       default-point-size 16
	       default-fontspec
	       (format default-fontspec-format   
		       default-font-family 
		       default-style
		       default-point-size
		       default-weight))
	      (set-face-attribute 'default nil :font default-fontspec))
	     ((eq window-system 'x)
	      (setq
	       default-font-family "helvetica"
	       default-style "normal"
	       default-point-size 14
	       default-fontspec
	       (format default-fontspec-format   
		       default-font-family
		       default-style
		       default-point-size
		       default-weight))
	      (set-face-attribute 'default nil :font default-fontspec))
	     )
       )
  ; if window-system isnt bound or set , don't set a face
  ; (face-attribute 'default :family)
  ;   todo: advise set-face-attribute  (debug) to see who's overriding this...
  ;   (debug-on-entry 'set-face-attribute)
  )
; XXX this is overridden somewhere, and besides should be window system dependent
; (window-system-faces)
; (add-hook 'after-init-hook ' window-system-faces)

(defun indicated-font () (interactive)
  (set-face-attribute 'default nil :font (indicated-word)))
