; this is all just one bad idea after another

(defvar default-font-pattern "-*-helvetica-medium-r-normal-*-%d-*-*-*-p-*-iso8859-1")

(setq default-font-pattern  "-*-helvetica-medium-r-normal-*-%d-*-*-*-p-*-iso8859-1")
; (setq default-font-pattern "-b&h-lucida-medium-r-normal-sans-%d-140-100-100-p-114-iso8859-1")
; (setq default-font-pixel-size-index 4)

(defvar default-font-pixel-sizes (apply 'vector '(8 10 11 12 14 17 18 20)))

(defvar default-font-pixel-size-index 4)

(defun current-font-pattern () (interactive)
  (let ((pat (format default-font-pattern
		     (aref default-font-pixel-sizes default-font-pixel-size-index))))
    (kill-new pat)
    (message pat)
    )
  )
; (current-font-pattern)

(defun font-1 () (interactive)
; (debug)
  (setq default-font-pixel-size-index (1- default-font-pixel-size-index))
  (if (< default-font-pixel-size-index 0)
      (setq default-font-pixel-size-index 0))

  (set-face-attribute 'default nil :font 
		      (format default-font-pattern
			      (aref default-font-pixel-sizes default-font-pixel-size-index))
		      )
  )

(defun font+1 () (interactive)

  (setq default-font-pixel-size-index (1+ default-font-pixel-size-index))
  (if (> default-font-pixel-size-index (1- (length default-font-pixel-sizes)))
      (setq default-font-pixel-size-index 
	    (1- (length default-font-pixel-sizes))))

  (set-face-attribute 'default nil :font 
		      (format default-font-pattern
			      (aref default-font-pixel-sizes default-font-pixel-size-index))
		      )
  )

(global-set-key (vector 'M-kp-add)  'font+1)
(global-set-key (vector 'M-kp-subtract) 'font-1)

; (kill-new (pp (aref (read-key-sequence "press a key sequence") 0)))

