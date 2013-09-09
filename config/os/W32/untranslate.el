(put 'untranslate 'rcsid 
 "$Id$")
(provide 'untranslate)

(defun find-buffer-file-type (filename)
  ;; First check if file is on an untranslated filesystem, then on the alist.
  (if (untranslated-file-p filename)
      t ; for binary
    (let ((alist file-name-buffer-file-type-alist)
          (found nil)
          (code nil))
      (let ((case-fold-search t))
        (setq filename (file-name-sans-versions filename))
        (while (and (not found) alist)
          (if (string-match (car (car alist)) filename)
              (setq code (cdr (car alist))
                    found t))
          (setq alist (cdr alist))))
      (if found
          (cond ((memq code '(nil t)) code)
                ((and (symbolp code) (fboundp code))
                 (funcall code filename)))
        buffer-file-type))))

(defun find-file-binary (filename) 
  "Visit file FILENAME and treat it as binary."
  (interactive "FFind file binary: ")
  (let ((file-name-buffer-file-type-alist '(("" . t))))
    (find-file filename)))

(defun find-file-text (filename) 
  "Visit file FILENAME and treat it as a text file."
  (interactive "FFind file text: ")
  (let ((file-name-buffer-file-type-alist '(("" . nil))))
    (find-file filename)))

(defun find-file-not-found-set-buffer-file-type ()
  (with-current-buffer (current-buffer)
    (setq buffer-file-type (find-buffer-file-type (buffer-file-name))))
  nil)

;;; To set the default file type on new files.
(add-hook 'find-file-not-found-hooks 'find-file-not-found-set-buffer-file-type)


;;; To accomodate filesystems that do not require CR/LF translation.
(defvar untranslated-filesystem-list nil
  "List of filesystems that require no CR/LF translation when reading 
and writing files.  Each filesystem in the list is a string naming
the directory prefix corresponding to the filesystem.")

(defun untranslated-canonical-name (filename)
  "Return FILENAME in a canonicalized form for use with the functions
dealing with untranslated filesystems."
  (if (memq system-type '(ms-dos windows-nt))
      ;; The canonical form for DOS/NT/Win95 is with A-Z downcased and all
      ;; directory separators changed to directory-sep-char.
      (let ((name nil))
        (setq name (mapconcat 
                    (lambda (char) 
                       (if (and (<= ?A char) (<= char ?Z))
                           (char-to-string (+ (- char ?A) ?a))
                         (char-to-string char)))
                    filename nil))
        ;; Use expand-file-name to canonicalize directory separators, except
        ;; with bare drive letters (which would have the cwd appended).
        (if (string-match "^.:$" name)
            name
          (expand-file-name name)))
    filename))

(defun untranslated-file-p (filename)
  "Return t if FILENAME is on a filesystem that does not require 
CR/LF translation, and nil otherwise."
  (let ((fs (untranslated-canonical-name filename))
        (ufs-list untranslated-filesystem-list)
        (found nil))
    (while (and (not found) ufs-list)
      (if (string-match (concat "^" (car ufs-list)) fs)
          (setq found t)
        (setq ufs-list (cdr ufs-list))))
    found))

(defun add-untranslated-filesystem (filesystem)
  "Add FILESYSTEM to the list of filesystems that do not require
CR/LF translation.  FILESYSTEM is a string containing the directory
prefix corresponding to the filesystem.  For example, for a Unix 
filesystem mounted on drive Z:, FILESYSTEM could be \"Z:\"."
  (let ((fs (untranslated-canonical-name filesystem)))
    (if (member fs untranslated-filesystem-list)
        untranslated-filesystem-list
      (setq untranslated-filesystem-list
            (cons fs untranslated-filesystem-list)))))

(defun remove-untranslated-filesystem (filesystem)
  "Remove FILESYSTEM from the list of filesystems that do not require 
CR/LF translation.  FILESYSTEM is a string containing the directory
prefix corresponding to the filesystem.  For example, for a Unix 
filesystem mounted on drive Z:, FILESYSTEM could be \"Z:\"."
  (setq untranslated-filesystem-list 
        (delete (untranslated-canonical-name filesystem)
                untranslated-filesystem-list)))
