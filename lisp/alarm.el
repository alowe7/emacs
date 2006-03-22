(defun alarm (msg timeout) 
  (interactive "smessage: \nntimeout: ")
  (let ((i (make-itimer)))
    (setq *alarm-message* msg)
    (set-itimer-function i '(lambda () (let ((visible-bell t)) (ding) (message *alarm-message*))))
    (set-itimer-value i timeout)
    (activate-itimer i)
    )
  )