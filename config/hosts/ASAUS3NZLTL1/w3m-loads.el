(setq browse-url-browser-function 'w3m-browse-url)
(autoload 'w3m "w3m"  "invoke w3m web browser" t)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)

(global-set-key "\C-xw" 'w3m)
(global-set-key "\C-xm" 'browse-url-at-point)

(provide 'w3m-loads)
