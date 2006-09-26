(put 'keys 'rcsid 
 "$Id: keys.el,v 1.63 2006-09-26 18:56:13 alowe Exp $")
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
(define-key ctl-x-5-map "=" 'delete-duplicate-frames)
(define-key ctl-x-5-map "\C-m" '(lambda () (interactive) (switch-to-buffer-other-frame (current-buffer)))) 

(global-set-key (vector 24 67108923) 'indent-for-comment) ; C-x C-;

;(global-set-key "y" 'clipboard-yank)	;; emacs works as a clipboard viewer
(global-set-key "" 'goto-char)

(global-set-key "" 'auto-fill-mode) ; gets clobbered when cscope comes in
(global-set-key "c" 'calendar) ;
(global-set-key "x" 'calc) ;

(global-set-key "r." 'register-to-point)

; ctl-x-map
(global-set-key  "" 'kill-buffer)
(global-set-key "\C-m" 'compile)
(global-set-key "" 'pwd)

(global-set-key "3" 'three)
; (global-set-key "<" '(lambda () (interactive) (scroll-left horizontal-scroll-delta)))
; (global-set-key ">" '(lambda () (interactive) (scroll-right horizontal-scroll-delta)))
(global-set-key "<" 'scroll-left)
(global-set-key ">" 'scroll-right)
; (global-set-key "c" ' compare-windows-2)
(global-set-key "c" 'compare-windows)
(global-set-key "l" 'what-line)
(global-set-key "t" 'todo)

; ctl-c-map
(global-set-key "" 'auto-save-mode)
(global-set-key "" 'bottom-of-window)
(global-set-key "" 'kill-compilation)


(global-set-key "" 'find-file-force-refresh)
(global-set-key "f" 'find-indicated-file)
(global-set-key "" 'search-forward-indicated-word)

(global-set-key "" 'insert-buffer)
(global-set-key "" 'kill-rectangle)
(global-set-key "" 'goto-line)
; (global-set-key "" 'manual-entry)

; (global-set-key "." 'find-tag-on-key)
(global-set-key "." 'modify-syntax-entry)

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
(global-set-key "m" '(lambda (dir) (interactive "screate dir: ") (shell-command (format "mkdir %s" dir)) (and (eq major-mode 'dired-mode) (revert-buffer))))
(global-set-key "n" 'note)
; (global-set-key "r" 'vm)
; (global-set-key "r" 'rmail)
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

;; (global-set-key "��" 'overwrite-mode)
;; (global-set-key "��" 'scroll-up)
;; (global-set-key "��" 'scroll-down)
;; (global-set-key "��" 'top-of-window)
;; (global-set-key "��" 'bottom-of-window)
;; (global-set-key "��" 'delete-char)
;; (global-set-key "��" 'previous-line)
;; (global-set-key "��" 'next-line)
;; (global-set-key "��" 'backward-char)
;; (global-set-key "��" 'forward-char)

(global-set-key (vector '\M-up) 'scroll-down-1)
(global-set-key (vector '\M-down) 'scroll-up-1)
;; (global-set-key "��" 'next-error)

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

(define-key help-map "" 'fapropos3)
(define-key help-map "" 'refine-apropos)
(define-key help-map "" 'help-for-map)
(define-key help-map "d" 'perldoc)

;; (global-set-key "��" 'tags-apropos)
;; (global-set-key "��" 'tags-search)

(global-set-key "\e#" 'calc-dispatch)

(global-set-key "44" 'split-window-horizontally)


(define-key emacs-lisp-mode-map ""  'debug-indicated-word)
(global-set-key "d"  'cd)

(global-set-key "\C-h\C-m" 'man)
(global-set-key "\215"  'cmd) ; alt-ret

; "\C-c\C-/"
; (dec "0x400002f")
(global-set-key (vector 3 67108911)	'fb/)

(global-set-key  "" 'decrypt-find-file)
(global-set-key  "" 'encrypt-save-buffer)
(global-set-key  "" 'encrypt-write-buffer)


(global-set-key "k" 'bootstrap-task)


(global-set-key "\M-;" (quote eval-expression))

(global-set-key (vector '\M-prior) 'bury-buffer-1)
(global-set-key (vector '\M-next) 'unbury-buffer)

;(global-set-key "\M-n" '(lambda () (interactive) (let* ((l (real-buffer-list)) (b (pop l))) (switch-to-buffer b))))
;(global-set-key "\M-p" '(lambda () (interactive) (let* ((l (real-buffer-list t)) (b (pop l))) (switch-to-buffer b))))

(unless (fboundp 'alt-SPC-prefix) 
    (define-prefix-command 'alt-SPC-prefix))

(unless (and (boundp 'alt-SPC-map) alt-SPC-map)
  (setq alt-SPC-map (symbol-function 'alt-SPC-prefix)))

(global-set-key  " " 'alt-SPC-prefix)

;; this particular set of key bindings are so obscure, they're a barrier to use.

(define-key alt-SPC-map " " 'roll-server-clients)
(define-key alt-SPC-map " " 'roll-buffer-list)
(define-key alt-SPC-map "," 'roll-scratch-buffers)
(define-key alt-SPC-map "." 'roll-buffer-with-mode)
(define-key alt-SPC-map "/" 'roll-buffer-with)
(define-key alt-SPC-map "?" '(lambda () (interactive) (message "")))
(define-key alt-SPC-map "\M-/" 'list-buffers-with)
(define-key alt-SPC-map "\M-6" 'list-buffers-not-modified)
(define-key alt-SPC-map "\M-8" 'list-buffers-modified)
(define-key alt-SPC-map "\M-?" '(lambda () (interactive) (help-for-map alt-SPC-map)))
(define-key alt-SPC-map "\M-i" 'list-buffers-in)
(define-key alt-SPC-map "\M-k" 'kill-buffers-mode)
(define-key alt-SPC-map "\M-l" 'roll-buffer-like)
(define-key alt-SPC-map "\M-m" 'list-buffers-mode)
(define-key alt-SPC-map "\M-~" 'kill-buffers-not-modified)
(define-key alt-SPC-map "b" '(lambda () (interactive) (list-buffers-mode 'scratch-mode)))
(define-key alt-SPC-map "l" 'roll-buffer-like)
(define-key alt-SPC-map "m" 'roll-buffer-named)
(define-key alt-SPC-map "n" 'iconify-frame)
(define-key alt-SPC-map "o" 'roll-buffer-mode)
(define-key alt-SPC-map "\M-o" 'roll-buffer-mode)
(define-key alt-SPC-map "s" 'first-shell)
(define-key alt-SPC-map "" 'roll-buffer-no-files)
(define-key alt-SPC-map (vector 'return) 'bury-buffer)
(define-key ctl-x-map " " 'roll-buffer-list)

(global-set-key (vector '\C-tab) 'set-tabs)
(global-set-key "" 'describe-key-sequence)
(define-key help-map "" 'find-function-or-variable)

(defvar ctl (dec "0x4000000"))
(defun ctl (c) (+ ctl c))

; maybe the flag key
(defvar meta (dec "0x800000"))
(defun meta (c) (+ meta c))

; use generally for info commands
(unless (fboundp 'ctl-\?-prefix)
    (define-prefix-command 'ctl-\?-prefix))

(unless (and (boundp 'ctl-\?-map) ctl-\?-map)
  (setq ctl-\?-map (symbol-function 'ctl-\?-prefix)))

(global-set-key (vector (ctl ??)) 'ctl-\?-prefix)

(define-key ctl-\?-map "	" '(lambda () (interactive)   (message "tab-width: %d" tab-width)))
; mail-quote
(global-set-key ">" '(lambda () (interactive) (save-excursion (goto-char (point-min)) (replace-regexp "^" "> " nil))))

(define-key ctl-x-4-map "" 'bury-buffer)


(require 'ctl-slash)

(define-key ctl-/-map "f" 'locate)
(define-key ctl-/-map "" 'locate-with-filter)

(define-key ctl-/-map "/" 'vars-like-with)

(require 'cl)

; create scratch buffers with various default modes
(define-key ctl-/-map "4"
  `(lambda (&optional arg) (interactive "P") (switch-to-buffer (get-scratch-buffer arg))))

; what's this about?
(global-set-key "\M-" 'backward-word)
(global-set-key "\M-\\" 'forward-word)

(require 'ctl-ret)

(define-key ctl-RET-map "e" 'edit-bookmarks)
(define-key ctl-RET-map "m" 'bookmark-set)

(provide 'keys)

