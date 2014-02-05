(put 'keys 'rcsid 
 "$Id$")

(require 'ctl-meta)

;; these is some fancy key bindings

(define-key ctl-x-5-map "-" 'delete-all-other-frames)
(define-key ctl-x-5-map "=" 'delete-duplicate-frames)
(define-key ctl-x-5-map "\C-m" (function (lambda () (interactive) (switch-to-buffer-other-frame (current-buffer))))) 

(global-set-key (vector 24 67108923) 'indent-for-comment) ; C-x C-;

(global-set-key "\M-\C-y" 'clipboard-yank)
(global-set-key "\C-c\C-]" 'goto-char)
(global-set-key "\C-c\C-i" 'move-to-column)

(global-set-key "\C-c\C-\\" 'auto-fill-mode)
(global-set-key "\C-cc" 'calendar) ;
(global-set-key "\C-cx" 'calc) ;

(global-set-key "\C-xr." 'register-to-point)

; ctl-x-map
(global-set-key  "\C-x\C-k" 'kill-buffer)
(global-set-key "\C-x\C-m" 'compile)
(global-set-key "\C-x\C-p" 'pwd)
; (global-set-key  "\C-x\C-b" 'list-buffers)

(global-set-key "\C-x3" 'three)
; (global-set-key "\C-x<" (lambda () (interactive) (scroll-left horizontal-scroll-delta)))
; (global-set-key "\C-x>" (lambda () (interactive) (scroll-right horizontal-scroll-delta)))
(global-set-key "\C-x<" 'scroll-left)
(global-set-key "\C-x>" 'scroll-right)
; (global-set-key "\C-xc" ' compare-windows-2)
(global-set-key "\C-xc" 'compare-windows)
(global-set-key "\C-xl" 'what-line)
(global-set-key "\C-xt" 'todo)

; ctl-c-map
(global-set-key "\C-c\C-a" 'auto-save-mode)
(global-set-key "\C-c\C-b" 'bottom-of-window)
(global-set-key "\C-c\C-c" 'kill-compilation)


(global-set-key "\C-c\C-f" 'find-file-force-refresh)
(global-set-key "\C-cf" 'find-indicated-file)
(global-set-key "\C-c\C-s" 'search-forward-indicated-word)

(global-set-key "\C-c\C-g" 'insert-buffer)
(global-set-key "\C-c\C-k" 'kill-rectangle)
(global-set-key "\C-c\C-l" 'goto-line)
; (global-set-key "\C-c" 'manual-entry)

; (global-set-key "\C-c." 'find-tag-on-key)
(global-set-key "\C-c." 'modify-syntax-entry)

(global-set-key "\C-c\C-o" (function (lambda () (interactive) (roll-buffer-list t))))

(global-set-key "\C-c\C-q" 'fill-region)
(global-set-key "\C-c\C-r" 'current-word-search-backward)
(global-set-key "\C-c\C-s" 'current-word-search-forward)
(global-set-key "\C-c\C-t" 'top-of-window)
(global-set-key "\C-c\C-v" 'insert-eval-environment-variable)
(global-set-key "\C-c\C-w" 'kill-to-cut-buffer)
(global-set-key "\C-c\C-y" 'yank-rectangle)
(global-set-key "\C-c<" 'enlarge-window-horizontally)
(global-set-key "\C-c=" 'count-lines-page)
(global-set-key "\C-c`" 'ftp-find-file)

(global-set-key "\C-cf" 'find-alternate-file)
(global-set-key "\C-cf" (quote view-file))
(global-set-key "\C-cg" 'grep)
(global-set-key "\C-ch" 'howto)
(global-set-key "\C-cl" 'move-to-window-line)
(global-set-key "\C-cm" (function (lambda (dir) (interactive "screate dir: ") (shell-command (format "mkdir %s" dir)) (and (eq major-mode 'dired-mode) (revert-buffer)))))
(global-set-key "\C-cn" 'note)
; (global-set-key "\C-cr" 'vm)
; (global-set-key "\C-cr" 'rmail)
(global-set-key "\C-cs" 'spell-region)
(global-set-key "\C-cv" 'html-view)
;(global-set-key "\C-cm" 'x-flush-mouse-queue)
;; (global-set-key "\C-ct" 'telnet)
;; see below. (global-set-key "\C-cn" 'rnews)
;;(global-set-key "\C-c\C-d" 'cd)
;;(global-set-key "\C-cd" 'indicated-dec)
;;(global-set-key "\C-ch" 'indicated-hex)
;;(global-set-key "\C-cm" 'mymail)


; esc-map
(global-set-key "\M-+" 'toggle-debug-on-error)
(global-set-key "\M-_" 'debug-indicated-word)


(global-set-key "\M-\C-l" 'eval-buffer)
; (global-set-key "\M-" (function (lambda nil (interactive) (shell 1))))
; (global-set-key "\C-x<CONTROL-J>" (function (lambda nil (interactive) (shell 2))))
(global-set-key "\M-" 'shell2)
(global-set-key "\M-&" 'replace-string)
(global-set-key "\M-*" 'replace-regexp)
(global-set-key "\M-c" 'capitalize-word)
(global-set-key "\M-m" 'other-window)
(global-set-key "\M-o" 'other-window-1)
(global-set-key "\M-r" 'word-search-backward)
(global-set-key "\M-s" 'word-search-forward)
(global-set-key "\M-{" 'backward-up-list)
(global-set-key "\M-}" 'up-list)

; function keys
(global-set-key "\M-OT" 'findwhence)
(global-set-key "\M-OV" 'cd)

; (global-set-key "\M-\C-y" 'yow)
; (global-set-key "\M-\C-q" 'flame)
; (global-set-key "\M-\C-r" 'caesar-region)

; define standard cursor keys, etc

;; (global-set-key "ã" 'overwrite-mode)
;; (global-set-key "Ö" 'scroll-up)
;; (global-set-key "Õ" 'scroll-down)
;; (global-set-key "Ð" 'top-of-window)
;; (global-set-key "×" 'bottom-of-window)
;; (global-set-key "ÿ" 'delete-char)
;; (global-set-key "Ò" 'previous-line)
;; (global-set-key "Ô" 'next-line)
;; (global-set-key "Ñ" 'backward-char)
;; (global-set-key "Ó" 'forward-char)

(global-set-key (vector '\M-up) 'scroll-down-1)
(global-set-key (vector '\M-down) 'scroll-up-1)
;; (global-set-key "à" 'next-error)

;;(define-key ctl-x-4-map "s" 'fileness)
;;(define-key ctl-x-4-map "w" 'wordness)

(define-key ctl-x-4-map "a" 'ascii-region)
(define-key ctl-x-4-map "c" 'caesar-buffer)
(define-key ctl-x-4-map "e" 'env)
(define-key ctl-x-4-map "q" 'flame)
(define-key ctl-x-4-map "r" 'rename-buffer)
(define-key ctl-x-4-map "v" 'inv)
(define-key ctl-x-4-map "w" (function (lambda () (interactive) (findwhence (indicated-word)))))
(define-key ctl-x-4-map "y" 'yow)


; (define-key help-map "" 'indicated-manual-entry)

(define-key help-map "\C-a" 'fapropos3)
(define-key help-map "\C-r" 'refine-apropos)
(define-key help-map "\C-k" 'help-for-map)
(define-key help-map "." 'lwhence)

;; (global-set-key "º" 'tags-apropos)
;; (global-set-key "¢" 'tags-search)

(global-set-key "\e#" 'calc-dispatch)

(global-set-key "\C-x44" 'split-window-horizontally)


(define-key emacs-lisp-mode-map "\C-x,"  'debug-indicated-word)
(global-set-key "\C-cd"  'cd)

(global-set-key "\C-h\C-m" 'man)
(global-set-key "\215"  'cmd) ; alt-ret

; "\C-c\C-/"
; (dec "0x400002f")
(global-set-key (vector 3 67108911) 'fb/)

(global-set-key  "\C-cC-x" 'decrypt-find-file)
(global-set-key  "\C-cC-x" 'encrypt-save-buffer)
(global-set-key  "\C-cC-x" 'encrypt-write-buffer)


(global-set-key "\C-ck" 'bootstrap-task)


(global-set-key "\M-;" (quote eval-expression))

(global-set-key (vector '\M-prior) 'bury-buffer-1)
(global-set-key (vector '\M-next) 'unbury-buffer)

;(global-set-key "\M-n" (function (lambda () (interactive) (let* ((l (real-buffer-list)) (b (pop l))) (switch-to-buffer b)))))
;(global-set-key "\M-p" (function (lambda () (interactive) (let* ((l (real-buffer-list t)) (b (pop l))) (switch-to-buffer b)))))

(require 'alt-spc)

;; this particular set of key bindings are so obscure, they're a barrier to use.

(define-key alt-SPC-map " " 'roll-buffer-with-mode)
(define-key alt-SPC-map "\M-," 'roll-scratch-buffers)
(define-key alt-SPC-map "." 'roll-server-clients)
(define-key alt-SPC-map " " 'roll-buffer-list)


(define-key alt-SPC-map "?" (function (lambda () (interactive) (message ""))))
(define-key alt-SPC-map "\M-/" 'list-buffers-with)
(define-key alt-SPC-map "\M-6" 'list-buffers-not-modified)
(define-key alt-SPC-map "\M-8" 'list-buffers-modified)
(define-key alt-SPC-map "\M-?" (function (lambda () (interactive) (help-for-map alt-SPC-map))))
(define-key alt-SPC-map "\M-i" 'list-buffers-in)
(define-key alt-SPC-map "\M-k" 'kill-buffers-mode)
(define-key alt-SPC-map "\M-m" 'list-buffers-mode)
(define-key alt-SPC-map "\M-~" 'kill-buffers-not-modified)
(define-key alt-SPC-map "b" (function (lambda () (interactive) (list-buffers-mode 'scratch-mode))))
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
(global-set-key "\C-c" 'describe-key-sequence)
(define-key help-map "" 'find-function-or-variable)

; use generally for info commands
(unless (fboundp 'ctl-\?-prefix)
    (define-prefix-command 'ctl-\?-prefix))

(unless (and (boundp 'ctl-\?-map) ctl-\?-map)
  (setq ctl-\?-map (symbol-function 'ctl-\?-prefix)))

(global-set-key (vector (ctl ??)) 'ctl-\?-prefix)

(define-key ctl-\?-map "	" (function (lambda () (interactive)   (message "tab-width: %d" tab-width))))

; mail-quote
(global-set-key "\C-c>" (function (lambda () (interactive) (save-excursion (goto-char (point-min)) (while (re-search-forward  "^" nil t) (replace-match "> " nil nil))))))

(define-key ctl-x-4-map "" 'bury-buffer)


(require 'ctl-slash)

(define-key ctl-/-map "u" 'makeunbound)
(define-key ctl-/-map "f" 'locate)
(define-key ctl-/-map "" 'locate-with-filter)
(define-key ctl-/-map "/" 'vars-like-with)

(require 'cl)
(require 'ctl-ret)

; create scratch buffers with various default modes
(define-key ctl-/-map "4" 'switch-to-new-scratch-buffer)
(define-key ctl-/-map (vector (ctl ?4)) 'pop-to-last-scratch-buffer)
(define-key ctl-/-map "1" 'yank-to-new-scratch-buffer)
(define-key ctl-/-map (vector (ctl ?1)) 'list-scratch-buffers)

; what's this about?
(global-set-key "\M-" 'backward-word)
(global-set-key "\M-\\" 'forward-word)

(define-key ctl-RET-map "e" 'edit-bookmarks)
(define-key ctl-RET-map "m" 'bookmark-set)

(define-key ctl-RET-map "\C-w" 'command-history)

(define-key ctl-RET-map (vector (ctl ?7)) 'lru-shell)
(define-key ctl-RET-map (vector (ctl ?8)) 'mru-shell)

(define-key ctl-/-map (vector (ctl ? )) 'myblog)
(define-key ctl-/-map "g" 'grepblog)
(define-key ctl-/-map "l" 'find-lastblog)

; that's a hole nutha thang
(require 'ctl-dot)

(require 'ctl-backslash)

(provide 'keys)

