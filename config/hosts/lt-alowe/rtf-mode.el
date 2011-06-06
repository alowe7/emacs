(add-to-load-path "/z/el" t)
(autoload 'rtf-mode "rtf-mode" "RTF mode" t)
(add-to-list 'auto-mode-alist
  '("\\.rtf$" . rtf-mode))
