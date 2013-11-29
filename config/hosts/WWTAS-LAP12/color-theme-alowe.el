
(fset 'color-theme-alowe
      (lambda nil "The color theme in use when the selection buffer was created.\n\\[color-theme-select] creates the color theme selection buffer.  At the\nsame time, this snapshot is created as a very simple undo mechanism.\nThe snapshot is created via `color-theme-snapshot'."
	(interactive)
	(color-theme-install
	 '(color-theme-snapshot
	   ((background-color . "white")
	    (background-mode . light)
	    (border-color . "black")
	    (cursor-color . "black")
	    (foreground-color . "black")
	    (mouse-color . "black"))
	   ((compilation-message-face . underline)
	    (list-matching-lines-buffer-name-face . underline)
	    (list-matching-lines-face . match)
	    (view-highlight-face . highlight)
	    (widget-mouse-face . highlight))
	   (default
	     ((t
	       (:stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "outline" :family "Calibri"))))
	   (bold
	    ((t
	      (:bold t :weight bold))))
	   (bold-italic
	    ((t
	      (:italic t :bold t :slant italic :weight bold))))
	   (border
	    ((t
	      (nil))))
	   (buffer-menu-buffer
	    ((t
	      (:bold t :weight bold))))
	   (button
	    ((t
	      (:underline t :foreground "RoyalBlue3"))))
	   (comint-highlight-input
	    ((t
	      (:bold t :weight bold))))
	   (comint-highlight-prompt
	    ((t
	      (:foreground "medium blue"))))
	   (compilation-column-number
	    ((t
	      (:foreground "VioletRed4"))))
	   (compilation-error
	    ((t
	      (:bold t :weight bold :foreground "Red1"))))
	   (compilation-info
	    ((t
	      (:bold t :weight bold :foreground "ForestGreen"))))
	   (compilation-line-number
	    ((t
	      (:foreground "Purple"))))
	   (compilation-mode-line-exit
	    ((t
	      (:bold t :foreground "ForestGreen" :weight bold))))
	   (compilation-mode-line-fail
	    ((t
	      (:bold t :foreground "Red1" :weight bold))))
	   (compilation-mode-line-run
	    ((t
	      (:bold t :foreground "DarkOrange" :weight bold))))
	   (compilation-warning
	    ((t
	      (:bold t :weight bold :foreground "DarkOrange"))))
	   (completions-annotations
	    ((t
	      (:italic t :slant italic))))
	   (completions-common-part
	    ((t
	      (:family "Calibri" :foundry "outline" :width normal :weight normal :slant normal :underline nil :overline nil :strike-through nil :box nil :inverse-video nil :foreground "black" :background "white" :stipple nil :height 120))))
	   (completions-first-difference
	    ((t
	      (:bold t :weight bold))))
	   (cursor
	    ((t
	      (:background "black"))))
	   (error
	    ((t
	      (:bold t :foreground "Red1" :weight bold))))
	   (escape-glyph
	    ((t
	      (:foreground "brown"))))
	   (file-name-shadow
	    ((t
	      (:foreground "grey50"))))
	   (fixed-pitch
	    ((t
	      (:family "Monospace"))))
	   (font-lock-builtin-face
	    ((t
	      (:foreground "dark slate blue"))))
	   (font-lock-comment-delimiter-face
	    ((t
	      (:foreground "Firebrick"))))
	   (font-lock-comment-face
	    ((t
	      (:foreground "Firebrick"))))
	   (font-lock-constant-face
	    ((t
	      (:foreground "dark cyan"))))
	   (font-lock-doc-face
	    ((t
	      (:foreground "VioletRed4"))))
	   (font-lock-function-name-face
	    ((t
	      (:foreground "Blue1"))))
	   (font-lock-keyword-face
	    ((t
	      (:foreground "Purple"))))
	   (font-lock-negation-char-face
	    ((t
	      (nil))))
	   (font-lock-preprocessor-face
	    ((t
	      (:foreground "dark slate blue"))))
	   (font-lock-regexp-grouping-backslash
	    ((t
	      (:bold t :weight bold))))
	   (font-lock-regexp-grouping-construct
	    ((t
	      (:bold t :weight bold))))
	   (font-lock-string-face
	    ((t
	      (:foreground "VioletRed4"))))
	   (font-lock-type-face
	    ((t
	      (:foreground "ForestGreen"))))
	   (font-lock-variable-name-face
	    ((t
	      (:foreground "sienna"))))
	   (font-lock-warning-face
	    ((t
	      (:bold t :weight bold :foreground "Red1"))))
	   (fringe
	    ((t
	      (:background "grey95"))))
	   (glyphless-char
	    ((t
	      (:height 0.6))))
	   (header-line
	    ((t
	      (:box
	       (:line-width -1 :style released-button)
	       :background "grey90" :foreground "grey20" :box nil))))
	   (help-argument-name
	    ((t
	      (:italic t :slant italic))))
	   (highlight
	    ((t
	      (:background "darkseagreen2"))))
	   (isearch
	    ((t
	      (:background "magenta3" :foreground "lightskyblue1"))))
	   (isearch-fail
	    ((t
	      (:background "RosyBrown1"))))
	   (italic
	    ((t
	      (:italic t :slant italic))))
	   (lazy-highlight
	    ((t
	      (:background "paleturquoise"))))
	   (link
	    ((t
	      (:foreground "RoyalBlue3" :underline t))))
	   (link-visited
	    ((t
	      (:underline t :foreground "magenta4"))))
	   (match
	    ((t
	      (:background "yellow1"))))
	   (menu
	    ((t
	      (:foreground "systemmenu" :background "systemmenutext"))))
	   (minibuffer-prompt
	    ((t
	      (:foreground "medium blue"))))
	   (mode-line
	    ((t
	      (:background "grey75" :foreground "black" :box
			   (:line-width -1 :style released-button)))))
	   (mode-line-buffer-id
	    ((t
	      (:bold t :weight bold))))
	   (mode-line-emphasis
	    ((t
	      (:bold t :weight bold))))
	   (mode-line-highlight
	    ((t
	      (:box
	       (:line-width 2 :color "grey40" :style released-button)))))
	   (mode-line-inactive
	    ((t
	      (:background "grey90" :foreground "grey20" :box
			   (:line-width -1 :color "grey75" :style nil)
			   :weight light))))
	   (mouse
	    ((t
	      (nil))))
	   (next-error
	    ((t
	      (:background "lightgoldenrod2"))))
	   (nobreak-space
	    ((t
	      (:foreground "brown" :underline t))))
	   (query-replace
	    ((t
	      (:foreground "lightskyblue1" :background "magenta3"))))
	   (region
	    ((t
	      (:background "lightgoldenrod2"))))
	   (scroll-bar
	    ((t
	      (:foreground "systemscrollbar"))))
	   (secondary-selection
	    ((t
	      (:background "yellow1"))))
	   (shadow
	    ((t
	      (:foreground "grey50"))))
	   (success
	    ((t
	      (:bold t :foreground "ForestGreen" :weight bold))))
	   (tool-bar
	    ((t
	      (:background "systembuttonface" :foreground "systembuttontext" :box
			   (:line-width 1 :style released-button)))))
	   (tooltip
	    ((t
	      (:family "Sans Serif" :background "systeminfowindow" :foreground "systeminfotext"))))
	   (trailing-whitespace
	    ((t
	      (:background "red1"))))
	   (underline
	    ((t
	      (:underline t))))
	   (variable-pitch
	    ((t
	      (:family "Sans Serif"))))
	   (vertical-border
	    ((t
	      (nil))))
	   (warning
	    ((t
	      (:bold t :foreground "DarkOrange" :weight bold))))
	   (widget-button
	    ((t
	      (:bold t :weight bold))))
	   (widget-button-pressed
	    ((t
	      (:foreground "red1"))))
	   (widget-documentation
	    ((t
	      (:foreground "dark green"))))
	   (widget-field
	    ((t
	      (:background "gray85"))))
	   (widget-inactive
	    ((t
	      (:foreground "grey50"))))
	   (widget-single-line-field
	    ((t
	      (:background "gray85")))))))
      )

; (color-theme-alowe)
