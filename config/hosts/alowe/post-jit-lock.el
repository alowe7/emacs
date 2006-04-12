(put 'post-jit-lock 'rcsid
 "$Id: post-jit-lock.el,v 1.1 2006-04-12 20:07:36 alowe Exp $")

; if this isn't fast enough for you, take a look at timer-set-time-with-usecs
; (setq jit-lock-stealth-time 1)

; this causes fontification to occur immediately
(setq jit-lock-stealth-time 0)

;; if an idle timer for stealth fontification already exists, need to reinitialize it
(if (and (featurep 'timer) (boundp 'jit-lock-stealth-timer) (timerp jit-lock-stealth-timer))
    (timer-set-idle-time jit-lock-stealth-timer jit-lock-stealth-time jit-lock-stealth-time))
