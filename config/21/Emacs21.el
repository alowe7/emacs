(put 'Emacs21 'rcsid
 "$Id: Emacs21.el,v 1.10 2004-02-03 19:36:21 cvs Exp $")

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

(defun fonty (font) (interactive "sfont: ")
  (set-face-attribute 'default nil :font  (default-font 
					    (setq default-font-family (string* font "verdana"))
					    (setq default-style "normal")
					    (setq default-point-size 16))
		      )
)

(defun remove-all-text-properties  (start end)
  "Remove all text properties from the region."
  (interactive "*r") ; error if buffer is read-only despite the next line.
  (and (text-properties-at (point))
       (remove-text-properties start end (text-properties-at (point))))
  )
