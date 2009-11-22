(put 'Emacs22 'rcsid
 "$Id: Emacs23.el,v 1.3 2009-11-22 17:42:17 alowe Exp $")

(define-key help-map "a" 'apropos)

; got used to using space for completion...
(define-key minibuffer-local-completion-map " " 'minibuffer-complete)
(define-key minibuffer-local-completion-map "	" 'minibuffer-complete-word)

; silence the dinger
(setq ring-bell-function '(lambda () nil))

; prevent tooltips on modeline hover
(setq tooltip-use-echo-area t)
; uncomment to disable tooltips entirely
; (tooltip-mode -1)

(defvar default-weight "normal")
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

; tbd completing-read from some alist...
; emacs23 (x-select-font) uses simplified font names like "Tahoma-14"

(defun fonty (font) 
  (interactive (list (read-string* (format "font (%s): " (default-font-family)))))

  (set-face-attribute 'default nil :font  (default-font
					    (setq default-font-family (string* font (string* default-font-family "verdana")))
					    (setq default-style "normal")
					    (setq default-point-size 16))
		      )
)

(defun remove-all-text-properties  (start end)
  "Remove all text properties from the region."
  (interactive "*r") ; error if buffer is read-only despite the next line.
  (loop for p from start to end do
	(let ((props (text-properties-at p)))
	  (remove-text-properties start end props))
	)
  )

; this fixes a problem in  Man-getpage-in-background where it tries to use cmdproxy to run shell script
(setq shell-file-name "sh")