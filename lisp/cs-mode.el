(put 'cs-mode 'rcsid
 "$Id$")

(require 'cc-mode)

; style for visualstudio cs

 (c-add-style 
  "cs"
  '("user"
    (c-basic-offset . 4)
    (c-comment-only-line-offset . 4)
    (c-block-comment-prefix . "* ")
    (c-comment-prefix-regexp
     (pike-mode . "//+!?\\|\\**")
     (other . "//+\\|\\**"))
    (c-cleanup-list scope-operator)
    (c-hanging-braces-alist
     (brace-list-open)
     (brace-entry-open)
     (substatement-open after)
     (block-close . c-snug-do-while)
     (extern-lang-open after)
     (inexpr-class-open after)
     (inexpr-class-close before))
    (c-hanging-colons-alist)
    (c-hanging-semi&comma-criteria c-semi&comma-inside-parenlist)
    (c-backslash-column . 48)
    (c-special-indent-hook)
    (c-label-minimum-indentation . 1)
    (c-offsets-alist
     (string . c-lineup-dont-change)
     (c . c-lineup-C-comments)
     (defun-open . 0)
     (defun-close . 0)
     (defun-block-intro . +)
     (class-open . 0)
     (class-close . 0)
     (inline-open . +)
     (inline-close . 0)
     (func-decl-cont . +)
     (knr-argdecl-intro . +)
     (knr-argdecl . 0)
     (topmost-intro . 0)
     (topmost-intro-cont . 0)
     (member-init-intro . +)
     (member-init-cont . c-lineup-multi-inher)
     (inher-intro . +)
     (inher-cont . c-lineup-multi-inher)
     (block-open . 0)
     (block-close . 0)
     (brace-list-open . 0)
     (brace-list-close . 0)
     (brace-list-intro . +)
     (brace-list-entry . 0)
     (brace-entry-open . 0)
     (statement . 0)
     (statement-cont . +)
     (statement-block-intro . +)
     (statement-case-intro . +)
     (statement-case-open . 0)
     (substatement . +)
     (substatement-open . +)
     (case-label . 0)
     (access-label . -)
     (label . 2)
     (do-while-closure . 0)
     (else-clause . 0)
     (catch-clause . 0)
     (comment-intro . c-lineup-comment)
     (arglist-intro . +)
     (arglist-cont . 0)
     (arglist-cont-nonempty . c-lineup-arglist)
     (arglist-close . +)
     (stream-op . c-lineup-streamop)
     (inclass . +)
     (cpp-macro .
                [0])
     (cpp-macro-cont . c-lineup-dont-change)
     (friend . 0)
     (objc-method-intro .
                        [0])
     (objc-method-args-cont . c-lineup-ObjC-method-args)
     (objc-method-call-cont . c-lineup-ObjC-method-call)
     (extern-lang-open . 0)
     (extern-lang-close . 0)
     (inextern-lang . +)
     (namespace-open . 0)
     (namespace-close . 0)
     (innamespace . +)
     (template-args-cont c-lineup-template-args +)
     (inlambda . c-lineup-inexpr-block)
     (lambda-intro-cont . +)
     (inexpr-statement . 0)
     (inexpr-class . +)))
  )

; (pop c-style-alist)



(defun indicated-isearch-forward ()
  (interactive)
  (push (thing-at-point 'word) search-ring)
  (call-interactively 'isearch-forward)
  )
(defun c-what-style ()
  (interactive)
  (when (and (boundp 'c-indentation-style) c-indentation-style) (message (format "c-indentation-style: %s" c-indentation-style)))
  )
(define-derived-mode cs-mode java-mode "CS" "visualstudio friendly style for c#"
  (setq c-syntactic-indentation t)
  (c-set-style "cs")
  (setq indent-tabs-mode nil)
  )

(define-key cs-mode-map "" 'indicated-isearch-forward)
(define-key cs-mode-map "?" 'c-what-style)
(define-key cs-mode-map (vector 'f7) 'c-show-syntactic-information)
(modify-syntax-entry ?_ "w" cs-mode-syntax-table)

(provide 'cs-mode)
