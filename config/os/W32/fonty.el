;; jean-luc fonty


(defun parse-font (font &optional attribute)
  (let* ((font-attributes '(
			   foundry
			   family
			   weight
			   slant
			   swidth
			   adstyle
			   pixelsize
			   pointsize
			   resx
			   resy
			   spacing
			   avgwidth
			   registry
			   encoding
			   ))
	(l (splice font-attributes (cdr (split font "-")))))
    (if attribute (assoc attribute l) l)
    )
  )

; (parse-font  "-outline-tahoma-normal-r-normal-normal-22-132-120-120-p-100-*-")
; (parse-font (frame-parameter nil 'font))

(defvar default-fontspec-format  "-*-%s-%s-r-*-*-%s-%s-*-*-*-*-*-*-")
(defvar default-fontspec nil)

(defvar default-family-table 
  (mapcar 'list 
	  (loop with l = nil for x in (x-list-fonts "*") unless (member x l) do (add-to-list 'l (cdr (parse-font x 'family))) finally return l)
	  ))

(defun default-font-family (&optional family) 
  "return family of frame's default font.
with optional FAMILY, changes it"
  (interactive (list (string* (read-string "family: ") (cdr (parse-font (frame-parameter nil 'font) 'family)))))

  (if family
      (set-frame-font
       (replace-in-string (cdr (parse-font (frame-parameter nil 'font) 'family))
			  family (frame-parameter nil 'font)))
    (or
     (cdr (parse-font (frame-parameter nil 'font) 'family))
     "lucida console"))
  )

(defun default-point-size ()
  (or (string-to-int (cdr (parse-font (frame-parameter nil 'font) 'pixelsize)))
      17)
  )
(defun default-style ()
  (or (cdr (parse-font (frame-parameter nil 'font) 'adstyle))
      "normal")
  )
(defun default-weight ()
  (or (cdr (parse-font (frame-parameter nil 'font) 'weight))
      "normal")
  )


(defun default-font (&optional font-family style point-size weight)
  (interactive (list
		(completing-read "Family: " default-family-table)
		(read-string "Style: ")
		(read-string "Point-size: ")
		(read-string "Weight: ")))

  (set-default-font (setq default-fontspec
			  (format default-fontspec-format   
				  (or font-family (default-font-family))
				  (or style (default-style))
				  (or point-size (default-point-size))
				  (or weight (default-weight)))))
  default-fontspec
  )

;(default-font nil "*" "100")

(defun font-1 (arg) (interactive "p")
  (default-font (default-font-family) (default-style) (- (default-point-size) (or arg 1)) nil)
  (if (interactive-p) (message default-fontspec))
  )

(defun font+1 (arg) (interactive "p")
  (default-font (default-font-family) (default-style) (+ (default-point-size) (or arg 1)) nil)
  (if (interactive-p) (message default-fontspec))
  )


