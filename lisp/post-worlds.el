(put 'post-worlds 'rcsid 
 "$Id: post-worlds.el,v 1.6 2001-07-18 22:32:41 cvs Exp $")

(global-set-key "\C-c\C-m" 'world)
(global-set-key (vector ? 'C-return) 'push-world)
(global-set-key "" 'pop-world)
(global-set-key "	" 'swap-world)
(global-set-key "" 'lastdir)
(global-set-key "" 'wn)


(setq *world-goto-lastdir* t)
(setq *shell-track-worlds* nil)

(setq *log-pre-log* t  *log-post-log* t)
