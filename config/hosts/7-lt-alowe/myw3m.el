(require 'w3m-load)
(require 'w3m)

(defvar *w3m-fixed-font* (fixed-font))
(setq *w3m-frame-height* 38)
(setq *w3m-frame-width* 90)
; centered on other frame
(setq *w3m-frame-top* (max 0 (/ (- (display-pixel-height)  (* *w3m-frame-height* (frame-char-height))) 2)))
(setq *w3m-frame-left* (+ (other-zero) (/ (- (other-width)  (* *w3m-frame-width* (frame-char-width))) 2)))

; open w3m in its own frame, ensuring that frame uses a fixed width font
(add-association `("*w3m*"  w3m-display-function
		   ((name . "w3m")
		    (title . "w3m")
		    (height . ,*w3m-frame-height*)
		    (width . ,*w3m-frame-width*)
		    (top . ,*w3m-frame-top*)
		    (left . ,*w3m-frame-left*)
		    (font . ,*w3m-fixed-font*)
		    (minibuffer)
		    (menu-bar-mode)))
		 'special-display-buffer-names 
		 t)

(defun w3m-display-function (buffer args)
  "this function should not be necessary"
  (let ((frame (make-frame (append args special-display-frame-alist))))
    (set-window-buffer (frame-selected-window frame) buffer)
    (set-window-dedicated-p (frame-selected-window frame) t)
    (set-variable 'truncate-lines t)
    (frame-selected-window frame))
  )
