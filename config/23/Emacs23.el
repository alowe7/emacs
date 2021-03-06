(put 'Emacs23 'rcsid
 "$Id$")

(require 'cl)

(define-key help-map "a" 'apropos)

; got used to using space for completion...
(define-key minibuffer-local-completion-map " " 'minibuffer-complete)
(define-key minibuffer-local-completion-map "	" 'minibuffer-complete-word)

; silence the dinger
(setq ring-bell-function (lambda () nil))

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

; determined by inspection of a bare load
(loop for x in  '(
		  help-fns
		  help-mode
		  easymenu
		  view
		  encoded-kb
		  tooltip
		  ediff-hook
		  vc-hooks
		  lisp-float-type
		  dos-w32
		  disp-table
		  ls-lisp
		  w32-win
		  w32-vars
		  tool-bar
		  mwheel
		  dnd
		  fontset
		  image
		  fringe
		  lisp-mode
		  register
		  page
		  menu-bar
		  rfn-eshadow
		  timer
		  select
		  scroll-bar
		  mouse
		  mldrag
		  jit-lock
		  font-lock
		  syntax
		  facemenu
		  font-core
		  frame
		  cham
		  georgian
		  utf-8-lang
		  misc-lang
		  vietnamese
		  tibetan
		  thai
		  tai-viet
		  lao
		  korean
		  japanese
		  hebrew
		  greek
		  romanian
		  slovak
		  czech
		  european
		  ethiopic
		  indian
		  cyrillic
		  chinese
		  case-table
		  epa-hook
		  jka-cmpr-hook
		  help
		  simple
		  abbrev
		  loaddefs
		  button
		  minibuffer
		  faces
		  cus-face
		  base64
		  md5
		  overlay
		  text-properties
		  format
		  env
		  code-pages
		  mule
		  custom
		  widget
		  backquote
		  )
      do
      (add-to-list 'hooked-preloaded-modules x)
      )

;; this shows just how ingrained certain emacs behaviors have become in my brain.

; default behavior changed in emacs23..?
(setq pop-up-windows nil)

; see split-window-sensibly
; split-height-threshold
; prefer split-window-vertically
(setq split-width-threshold nil)

(require 'images)


; obsolete with emacs 24.1

;;; Commands added by calc-private-autoloads on Sat Apr 17 19:09:31 2004.
(autoload 'calc-dispatch	   "calc" "Calculator Options" t)
(autoload 'full-calc		   "calc" "Full-screen Calculator" t)
(autoload 'full-calc-keypad	   "calc" "Full-screen X Calculator" t)
(autoload 'calc-eval		   "calc" "Use Calculator from Lisp")
(autoload 'defmath		   "calc" nil t t)
(autoload 'calc			   "calc" "Calculator Mode" t)
(autoload 'quick-calc		   "calc" "Quick Calculator" t)
(autoload 'calc-keypad		   "calc" "X windows Calculator" t)
(autoload 'calc-embedded	   "calc" "Use Calc inside any buffer" t)
(autoload 'calc-embedded-activate  "calc" "Activate =>'s in buffer" t)
(autoload 'calc-grab-region	   "calc" "Grab region of Calc data" t)
(autoload 'calc-grab-rectangle	   "calc" "Grab rectangle of data" t)
(setq load-path (nconc load-path (list "/usr/share/emacs/site-lisp/calc-2.02f")))
(global-set-key "\e#" 'calc-dispatch)
;;; End of Calc autoloads.
