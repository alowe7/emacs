(require 'nums)

;; all key bindings

; note:
; on win32 literal ^M characters don't survive some operations (such as cut and paste)
; so use \C-m construct instead

(defun char-ctrl (char)
	"set control on char"
	(logior (lsh 1 26) char))

(global-set-key "" 'shell2)
(define-key ctl-x-5-map "-" 'delete-all-other-frames)

(define-key ctl-x-5-map "\C-m" '(lambda () (interactive) 
																 (shell2 nil t)))
(global-set-key (vector 24 67108923) 'indent-for-comment) ; C-x C-;

;; ugh!
(define-key global-map (vector 27 'C-return) '(lambda () (interactive) (shell2 1)))


(global-set-key " " 'roll-buffer-list)
(global-set-key " " 'roll-buffer-like)
(global-set-key " " 'roll-buffer-mode)

;(global-set-key "y" 'clipboard-yank)	;; emacs works as a clipboard viewer

(global-set-key "" 'auto-fill-mode) ; gets clobbered when cscope comes in
(global-set-key "c" 'calendar) ;

(global-set-key "r." 'register-to-point)
(global-set-key "Ü" 'scroll-down-1)

; ctl-x-map
(global-set-key  "" 'kill-buffer)
(global-set-key "\C-m" 'compile)
(global-set-key "" 'pwd)
(global-set-key "" 'world)
(global-set-key (vector ? ? )  'roll-world-stack)
(global-set-key (vector ? (char-ctrl ? ))  'roll-world-list)

(global-set-key "3" 'three)
(global-set-key "<" '(lambda () (interactive) (scroll-left horizontal-scroll-delta)))
(global-set-key ">" '(lambda () (interactive) (scroll-right horizontal-scroll-delta)))
; (global-set-key "c" ' compare-windows-2)
(global-set-key "c" ' compare-windows)
(global-set-key "l" 'what-line)
(global-set-key "l" 'what-line)
(global-set-key "t" 'todo)
;(global-set-key "c" 'compare-windows)



; ctl-c-map
(global-set-key "" 'auto-save-mode)
(global-set-key "" 'bottom-of-window)
(global-set-key "" 'kill-compilation)




(global-set-key "" 'find-file-force-refresh)

(global-set-key "" 'insert-buffer)
(global-set-key "" 'kill-rectangle)
(global-set-key "" 'goto-line)
; (global-set-key "" 'manual-entry)
(global-set-key "" 'roll-buffer-list)

(global-set-key "." 'find-tag-on-key)

(global-set-key "" '(lambda () (interactive) (roll-buffer-list t)))	

(global-set-key "" 'fill-region)
(global-set-key "" 'current-word-search-backward)
(global-set-key "" 'current-word-search-forward)
(global-set-key "" 'top-of-window)
(global-set-key "" 'insert-eval-environment-variable)
(global-set-key "" 'kill-to-cut-buffer)
(global-set-key "" 'yank-rectangle)
(global-set-key "<" 'enlarge-window-horizontally)
(global-set-key "=" 'count-lines-page)
(global-set-key "`" 'ftp-find-file)

(global-set-key "f" 'find-alternate-file)
(global-set-key "f" (quote view-file))
(global-set-key "g" 'grep)
(global-set-key "h" 'howto)
(global-set-key "l" 'move-to-window-line)
(global-set-key "m" 'chmod)
(global-set-key "n" 'note)
(global-set-key "r" 'vm)
(global-set-key "s" 'spell-region)
(global-set-key "v" 'html-view)
;(global-set-key "m" 'x-flush-mouse-queue)
;; (global-set-key "t" 'telnet)
;; see below. (global-set-key "n" 'rnews)
;;(global-set-key "" 'cd)
;;(global-set-key "d" 'indicated-dec)
;;(global-set-key "h" 'indicated-hex)
;;(global-set-key "m" 'mymail)


; esc-map
(global-set-key "+" 'debug-on-error)
(global-set-key "_" 'debug-indicated-word)


(global-set-key "" 'eval-current-buffer)
; (global-set-key "" '(lambda nil (interactive) (shell 1)))
; (global-set-key "<CONTROL-J>" '(lambda nil (interactive) (shell 2)))
(global-set-key "" 'shell)
(global-set-key "&" 'replace-string)
(global-set-key "*" 'replace-regexp)
(global-set-key "c" 'capitalize-word)
(global-set-key "m" 'other-window)
(global-set-key "o" 'other-window-1)
(global-set-key "r" 'word-search-backward)
(global-set-key "s" 'word-search-forward)
(global-set-key "{" 'backward-up-list)
(global-set-key "}" 'up-list)

; function keys
(global-set-key "OT" 'findwhence)
(global-set-key "OV" 'cd)

; (global-set-key "" 'yow)
; (global-set-key "" 'flame)
; (global-set-key "" 'caesar-region)
; (global-set-key "" 'caesar-region)

; define standard cursor keys, etc

;; (global-set-key "ã" 'overwrite-mode)
;; (global-set-key "Ö" 'scroll-up)
;; (global-set-key "Õ" 'scroll-down)
;; (global-set-key "Ð" 'top-of-window)
;; (global-set-key "×" 'bottom-of-window)
;; (global-set-key "ÿ" 'delete-char)
;; (global-set-key "Ò" 'previous-line)
;; (global-set-key "Ô" 'next-line)
;; (global-set-key "Ñ" 'backward-char)
;; (global-set-key "Ó" 'forward-char)



(global-set-key "¿" 'scroll-down-1)
(global-set-key "¯" 'scroll-up-1)
(global-set-key "à" 'next-error)

;;(define-key ctl-x-4-map "s" 'fileness)
;;(define-key ctl-x-4-map "w" 'wordness)





(define-key ctl-x-4-map "a" 'ascii-region)
(define-key ctl-x-4-map "c" 'caesar-buffer)
(define-key ctl-x-4-map "e" 'env)
(define-key ctl-x-4-map "q" 'flame)
(define-key ctl-x-4-map "r" 'rename-buffer)
(define-key ctl-x-4-map "v" 'inv)
(define-key ctl-x-4-map "w" '(lambda () (interactive) (findwhence (indicated-word))))
(define-key ctl-x-4-map "y" 'yow)


; (define-key help-map "" 'indicated-manual-entry)

(define-key help-map "" '(lambda () (interactive) (call-interactively (if current-prefix-arg 'fapropos4 'fapropos3))))
(define-key help-map "" 'help-for-map)

(global-set-key "º" 'tags-apropos)
(global-set-key "¢" 'tags-search)

(global-set-key "\e#" 'calc-dispatch)

(global-set-key "44" 'split-window-horizontally)


(define-key emacs-lisp-mode-map ""  'debug-indicated-word)
(global-set-key "d"  'cd)

(global-set-key "\C-h\C-m" 'myman)
(global-set-key (vector (dec "0xff80000d")) 'dosfree) ; alt-ret

(global-set-key "." 'safe-find-tag)

; "\C-c\C-/"
; (dec "0x400002f")
(global-set-key (vector 3 67108911)	'fb/)

(defvar compilation-mode-map (make-sparse-keymap))

(define-key  compilation-mode-map "p" '(lambda () (interactive) (previous-qsave-search (get-buffer "*compilation*"))))
(define-key  compilation-mode-map "n" '(lambda () (interactive) (next-qsave-search (get-buffer "*compilation*"))))

(global-set-key  "" 'decrypt-find-file)
(global-set-key  "" 'encrypt-save-buffer)
(global-set-key  "" 'encrypt-write-buffer)


