(put 'Emacs21 'rcsid
 "$Id: Emacs21.el,v 1.3 2003-10-24 13:30:31 cvs Exp $")

(define-key help-map "a" 'apropos)

; got used to using space for completion...
(define-key minibuffer-local-completion-map " " 'minibuffer-complete)
(define-key minibuffer-local-completion-map "	" 'minibuffer-complete-word)

(set-face-attribute 'default nil :family "verdana" :height 100 :weight 'ultra-light)

; this is both pre-loaded and broken.  reload the protected version
(load-library "font-core")

 (if (file-directory-p "/cygwin/bin")
      (setenv "PATH" (concat "c:\\cygwin\\bin;" (getenv "PATH"))))

; (setenv "PATH" "C:\\oracle\\ora92\\bin;C:\\Program Files\\Oracle\\jre\\1.3.1\\bin;C:\\Program Files\\Oracle\\jre\\1.1.8\\bin;c:\\bin;c:\\usr\\local\\bin;c:\\contrib\\bin;c:\\usr\\local\\lib\\tw-3.01\\bin;c:\\usr\\local\\lib\\perl-5.6.1\\bin;c:\\j2sdk1.4.1_01\\bin;C:\\WINDOWS\\system32;C:\\WINDOWS;C:\\WINDOWS\\System32\\Wbem;C:\\Program Files\\Common Files\\Adaptec Shared\\System;;c:\\Program Files\\TightVNC;c:\\usr\\local\\lib\\putty-0.53b\\bin;C:\\Program Files\\Resource Kit\\;C:\\PlatformSDK\\bin;C:\\SFU\\common\\;C:\\Program Files\\Microsoft Visual Studio\\Common\\Tools\\WinNT;C:\\Program Files\\Microsoft Visual Studio\\Common\\MSDev98\\Bin;C:\\Program Files\\Microsoft Visual Studio\\Common\\Tools;C:\\Program Files\\Microsoft Visual Studio\\VC98\\bin")