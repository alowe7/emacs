(setq xwhome "d:/x/w32")

(defun blink () (interactive)
  (shell-command (format "%s/desktop.scf" xwhome))
)

(define-key ctl-x-5-map "" 'blink)
(define-key ctl-x-5-map (vector 'C-backspace) 'blink)

;; (key-description (read-key-sequence ""))

(defun quick-launch (&optional initcmd) (interactive)
  (let* ((d  "c:/Documents and Settings/alowe/Application Data/Microsoft/Internet Explorer/Quick Launch")
	 (f (mapcar '(lambda (x) (list (file-name-sans-extension x) x)) (get-directory-files d)))
	 (cmd (completing-read "quick launch? " f)))

    (and cmd (progn (cd d) (shell-command (cadr (assoc cmd f)))))
    )
  )

(define-key ctl-x-5-map "q" 'quick-launch)

(defun show () (interactive)
  (let* ((d  "c:/Documents and Settings/alowe/Application Data/Microsoft/Internet Explorer/Quick Launch"))
    (cd d) (shell-command "show.lnk")))

(define-key ctl-x-5-map "s" 'show)
; (global-set-key (vector 'f10) 'show)
