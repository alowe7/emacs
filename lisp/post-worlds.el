(put 'post-worlds 'rcsid 
 "$Id: post-worlds.el,v 1.5 2001-07-18 22:18:18 cvs Exp $")

(global-set-key "\C-c\C-m" 'world)
(global-set-key (vector ? 'C-return) 'push-world)
(global-set-key "" 'pop-world)
(global-set-key "	" 'swap-world)
(global-set-key "" 'lastdir)
(global-set-key "" 'wn)


(setq *world-goto-lastdir* t)
(setq *shell-track-worlds* nil)
