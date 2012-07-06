(put 'Emacs24 'rcsid
 "$Id: Emacs23.el 1017 2011-06-06 04:32:11Z alowe $")

(require 'cl)

(define-key help-map "a" 'apropos)

; got used to using space for completion...
(define-key minibuffer-local-completion-map " " 'minibuffer-complete)
(define-key minibuffer-local-completion-map "	" 'minibuffer-complete-word)

; silence the dinger
(setq ring-bell-function '(lambda () nil))

; uncomment to disable tooltips entirely
(tooltip-mode -1)

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

; this is to allow hooks for any preloaded features to be run at load time
; determined by inspection of features from a bare load

(defconst *Emacs24-features* '(help-fns time-date tooltip ediff-hook vc-hooks lisp-float-type mwheel dos-w32 disp-table ls-lisp w32-win w32-vars tool-bar dnd fontset image fringe lisp-mode register page menu-bar rfn-eshadow timer select scroll-bar mouse jit-lock font-lock syntax facemenu font-core frame cham georgian utf-8-lang misc-lang vietnamese tibetan thai tai-viet lao korean japanese hebrew greek romanian slovak czech european ethiopic indian cyrillic chinese case-table epa-hook jka-cmpr-hook help simple abbrev minibuffer loaddefs button faces cus-face files text-properties overlay sha1 md5 base64 format env code-pages mule custom widget hashtable-print-readable backquote make-network-process multi-tty emacs))

(loop for x in *Emacs24-features* do (add-to-list 'hooked-preloaded-modules x) )

;; this shows just how ingrained certain emacs behaviors have become in my brain.

; default behavior changed in emacs23..?
(setq pop-up-windows nil)

; see split-window-sensibly
; split-height-threshold
; prefer split-window-vertically
(setq split-width-threshold nil)

