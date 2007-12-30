; run xfontsel, then...
; (insert (x-get-selection))

(if (eq window-system 'x)

    (progn

;      (setq default-fontspec "-*-*-medium-r-normal-*-17-*-*-*-p-*-iso8859-1")
;      (setq default-fontspec "-*-lucida-medium-r-normal-*-14-140-*-*-*-*-iso8859-1")
      (setq default-fontspec "-adobe-helvetica-medium-r-normal--17-120-100-100-p-88-iso8859-1")
  ; (setq default-fontspec "-*-*-medium-r-normal-*-18-*-*-*-p-*-iso8859-1")

      (setq initial-frame-alist
	    `(
	      (top . 71)
	      (left . 111)
	      (width . 58)
	      (height . 36)
	      (background-mode . light)
	      (cursor-type . box)
	      (border-color . "black")
	      (cursor-color . "black")
	      (mouse-color . "black")
	      (background-color . "white")
	      (foreground-color . "black")
	      (vertical-scroll-bars)
	      (internal-border-width . 0)
	      (border-width . 2)
	      (font . ,default-fontspec)
	      (menu-bar-lines . 0)
	      (tool-bar-mode . nil)
	      )
	    )
      (setq default-frame-alist initial-frame-alist)

      )
  )

(provide 'whack-font)
