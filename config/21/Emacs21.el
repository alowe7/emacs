(put 'Emacs21 'rcsid
 "$Id: Emacs21.el,v 1.12 2004-05-19 02:50:16 cvs Exp $")

(define-key help-map "a" 'apropos)

; got used to using space for completion...
(define-key minibuffer-local-completion-map " " 'minibuffer-complete)
(define-key minibuffer-local-completion-map "	" 'minibuffer-complete-word)

; silence the dinger
(setq ring-bell-function '(lambda () nil))

(defvar default-weight "*")
(defvar *default-font-family* "tahoma")
(defvar *default-point-size* 16)

(defun window-system-faces ()
  (and (boundp 'window-system)
       (cond ((eq window-system 'w32)
  ;	      (setq font-height 104)
  ;	      (set-face-attribute 'default nil :family "arial" :height font-height :weight 'ultra-light))
	      (setq
	       default-fontspec-format  "-*-%s-%s-r-*-*-%s-%s-*-*-*-*-*-*-"
	       default-font-family  *default-font-family*
	       default-style "normal"
	       default-point-size *default-point-size*
	       default-fontspec
	       (format default-fontspec-format   
		       default-font-family 
		       default-style
		       default-point-size
		       default-weight))
	      (set-face-attribute 'default nil :font default-fontspec))
	     ((eq window-system 'x)
	      (setq
	       default-fontspec-format  "-*-%s-medium-r-%s-*-%s-%s-*-*-*-*-*-*"
; "-*-helvetica-medium-r-*-*-14-*-*-*-*-*-*-*-*"n
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
; (add-hook 'after-init-hook 'window-system-faces)

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
