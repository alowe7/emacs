(put 'hilit 'rcsid 
 "$Id: hilit.el,v 1.5 2000-10-03 16:50:28 cvs Exp $")
;;; From awdprime.austin.ibm.com!auschs!portal.austin.ibm.com!geraldo.cc.utexas.edu!cs.utexas.edu!math.ohio-state.edu!magnus.acs.ohio-state.edu!cis.ohio-state.edu!netcom.com!stig Mon Jul 19 23:57:06 1993
;;; Path: awdprime.austin.ibm.com!auschs!portal.austin.ibm.com!geraldo.cc.utexas.edu!cs.utexas.edu!math.ohio-state.edu!magnus.acs.ohio-state.edu!cis.ohio-state.edu!netcom.com!stig
;;; From: stig@netcom.com (Stig)
;;; Newsgroups: gnu.emacs.sources
;;; Subject: hilit19.el v1.5
;;; Date: 5 Jul 1993 20:40:56 -0400
;;; Organization: Tinker Systems
;;; Lines: 1062
;;; Sender: daemon@cis.ohio-state.edu
;;; Distribution: gnu
;;; Message-ID: <9307060035.AA29824@netcom.netcom.com>
;;; 
;;; Since I (and several others) had problems with the text properties, I've
;;; switched back to overlays.  Unhighlighting is slower, but highlighting is the
;;; same speed.  I've also added hilit-yank[-pop] and these two functions
;;; partially make up for the ability of text properties to be carried through cut
;;; and paste.
;;; 
;;; Read the history for other changes...
;;; 
;;;         Stig
;;; 
;;
;; hilit19.el v1.5 Copyright (C) 1993 Free Software Foundation, Inc.
;;
;; A package allowing customizable highlighting of Emacs19 buffers.
;;
;; AUTHOR:  Jonathan Stigelman <Stig@netcom.com>
;;
;; CONTRIBUTORS:  Vivek Khera <khera@cs.duke.edu>
;;		  ebert@enpc.enpc.fr (Rolf EBERT)
;;		  ctkwok@cs.washington.edu (Chung Tin Kwok)
;;		  brian@athe.WUstl.EDU (Brian Dunford-Shore)
;;		  John Ladwig <jladwig@soils.umn.edu>
;;
;; With suggestions and minor regex patches from numerous others...
;;
;; Created in true "stone soup" fashion (i.e.: 100% rewritten) from:
;;   hilit.el by pnakada@oracle.com, later modified by dliu@ace.njit.edu
;;

;;; This file seems like it might become part of GNU Emacs.
;;;
;;; GNU Emacs is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY.  No author or distributor
;;; accepts responsibility to anyone for the consequences of using it
;;; or for whether it serves any particular purpose or works at all,
;;; unless he says so in writing.  Refer to the GNU Emacs General Public
;;; License for full details.
;;;
;;; Everyone is granted permission to copy, modify and redistribute
;;; GNU Emacs, but only under the conditions described in the
;;; GNU Emacs General Public License.   A copy of this license is
;;; supposed to have been given to you along with GNU Emacs so you
;;; can know your rights and responsibilities.  It should be in a
;;; file named COPYING.  Among other things, the copyright notice
;;; and this notice must be preserved on all copies.
;;;

;; WHERE TO GET THE LATEST VERSION VIA ANONYMOUS FTP:
;;
;;      netcom.com:/pub/stig/src/hilit19.el

;; HISTORY 
;; V1.5  5-July-1993		Stig@netcom.com
;;   changed behavior of hilit-recenter to more closely match that of recenter
;;   hilit-auto-highlight can now be a list of major-modes to highlight on find
;;   reverted to using overlays...the cost of text-properties is too high, IMHO
;;   added 'visible option to hilit-auto-rehighlight variable
;;   now highlighting support for info pages (see patch below)
;;   added hilit-yank and hilit-yank-pop which replace their analogues
;;   wrote special parsing function for strings...bug squished...faster too
;;   tuned the texinfo patterns for better performance
;;   nroff support
;; V1.4  2-July-1993		Stig@netcom.com
;;   more efficient highlighting for news and mail
;;   switched to text properties (this may be temporary)
;;   changed regular expressions for c*mode to accomodate syntax tables
;;   minor mod to Ada parameter regexp
;;   now catch regex stack overflows and print an error
;;   string matching now uses start and end expressions to prevent overflows
;; V1.3 28-June-1993		Stig@netcom.com
;;   added support for hexadecimal color specification under X
;;   added hilit-translate for simple color translations
;;   changed coverage of hilit-quietly...when it's quiet, it's always quiet.
;;   removed extra call to unhighlight-region in rehighlight-buffer
;;   automatically installs hooks, unless hilit-inhibit-hooks set before load
;;   installed fixes for latex
;; V1.2 28-June-1993		Stig@netcom.com
;;   partially fixed bug in hilit-toggle-highlight
;;   added string highlighting
;;   fixed bug in hilit-lookup-face-create
;;   additions for Ada, Tex, LaTeX, and Texinfo (is scribe next? =)
;;   now highlight template decls in C++
;;   added reverse-* intelligence to hilit-lookup-face-create
;;   imported wysiwyg (overstrike replacement) stuff from my hacks to man.el
;;   sketched out a stub of a wysiwyg write file hook, care to finish it?
;; V1.1	25-June-1993		Stig@netcom.com
;;   replaced last vestiges of original hilit.el
;;   now map default modes to major-mode values
;;   reworked face allocation so that colors don't get tied up
;;   rewrote some comments that I'd put in earlier but somehow managed to nuke
;; V1.0 22-June-1993		Stig@netcom.com
;;   incrementally replaced just about everything...simpler, cleaner, & faster
;;   extended highlight coverage for C/C++ modes (highlight more things)
;;   added layer of indirection to face selection

;; GENERAL OVERVIEW
;;
;; This package works as follows
;;
;;      Set the appropriate hooks and watch as your boring black and white
;;      buffers magically become colorful.  Several modes have default
;;      colorings whose colors can be simply redefined without much hassle.
;;      (Make sure that if you redefine the patterns for a given mode, that
;;	you do it after loading this package.)
;;
;;      If, when you edit the buffer, the coloring gets messed up, just
;;      redraw and the coloring will be adjusted.  If automatic highlighting
;;      in the current buffer has been turned off (either because you've
;;      decided to do this or because the buffer is large) then invoking
;;      either redraw-screen or recenter (usually ^L) will highlight the 
;;	area of the buffer that you happen to be viewing.  Giving a prefix
;;	argument to a redraw command will force a rehighlight of the entire
;;	buffer...
;;
;;
;; Are you using the right font for Emacs?  Pick a font...
;;
;;  !Emacs.font: -schumacher-clean-medium-r-normal--16-160-75-75-c-80-iso8859-1
;;  !Emacs.font: -misc-fixed-medium-r-normal--13-120-*-*-c-*-iso8859-1
;;  Emacs.font:	 -misc-fixed-medium-r-normal--15-140-*-*-c-*-iso8859-1
;;  !Emacs.font: -adobe-courier-medium-r-normal--14-140-*-*-m-*-iso8859-1
;;
;; In your .emacs:
;; 
;;  (require 'hilit19)		; not intended to be autoloaded
;;
;;  (setq hilit-auto-highlight '(not text-mode fundamental-mode))
;;
;; Possible customizations...
;;
;;  (setq hilit-auto-highlight-maxout 70000) ; set a higher autohighlight max
;;
;;  (hilit-translate 'type 'RoyalBlue) ; enable type highlighting in C/C++
;;  (hilit-translate 'string nil)      ; disable string highlighting
;;
;; if you want to change the comments in only one mode LOCALLY...
;;
;;  (add-hook 'cookie-mode-hook
;;	      '(lambda () (make-local-variable 'hilit-face-translation-table)
;;			  (setq hilit-face-translation-table
;;				(copy-list hilit-face-translation-table))
;;			  (hilit-associate 'hilit-face-translation-table
;;					   'comment 'OatmealRaisin))
;;
;; Yet MORE useful hooks...
;;
;; you might, though I'm not, also be interested in rehighlighting when you
;; save your buffers:
;;
;;  (add-hook 'write-file-hooks 'hilit-rehighlight-buffer nil)

;; KNOWN BUGS/TO DO LIST/HELP WANTED/APPLY WITHIN (saw this in crypt++.el)
;;
;; * For various reasons, the speed of the package could stand to be improved.
;;   If you care to do a little profiling and make things tighter...
;;
;; * hilit-toggle-highlight is flaky in large buffers where auto-rehighlight
;;   is numeric after toggling twice, it loses it's numeric value
;;
;; * partial rehighlights can cause formatting of multi-line regions to come
;;   undone.  Examples are comments in C and strings in lisp (or C).
;;
;; * it would be nice if hilit-lookup-face-create would parse background colors
;;   foreground/background-bold-italic-underline
;;
;; PROJECTS THAT YOU CAN TAKE OVER BECAUSE I DON'T MUCH CARE ABOUT THEM...
;;
;; * Moved hilit-wysiwyg-replace here from my version of man.el, this is not
;;   a bug.  The bug is that I don't have a reverse operation yet...just a stub
;;   Wysiwyg-anything really belongs in a package of it's own.


;;;;;; THIS WILL ALLOW INFO PAGES TO BE HILIGHTED:
;;
;; *** 19/info.el  Mon May 31 10:55:51 1993
;; --- info.el     Sat Jul  3 02:27:01 1993
;; ***************
;; *** 458,464 ****
;;                                   (setq active-expression
;;                                         (read (current-buffer))))))
;;                          (point-max)))
;; !      (if Info-enable-active-nodes (eval active-expression)))))
;;   
;;   (defun Info-set-mode-line ()
;;     (setq mode-line-buffer-identification
;; --- 458,466 ----
;;                                   (setq active-expression
;;                                         (read (current-buffer))))))
;;                          (point-max)))
;; !      (if Info-enable-active-nodes (eval active-expression)))
;; !   (run-hooks 'Info-select-hook)
;; !   ))
;;   
;;   (defun Info-set-mode-line ()
;;     (setq mode-line-buffer-identification
;;;;;;


(defvar hilit-quietly nil
  "If non-nil, this inhibits progress indicators during highlighting")

(defvar hilit-inhibit-hooks nil
  "If non-nil, this inhibits automatic addition of hooks for gnus and vm")

(defvar hilit-no-color nil
  "If this is non-nil, then always use font changes instead of color.")

(defvar hilit-auto-highlight t
  "T if we should highlight all buffers as we find 'em, or a list of
  major-modes whose files are highlighted automatically, nil to disable
  automatic highlighting by the find-file hook.  If a list of modes is used,
  the sense of the list is negated if it begins with the symbol 'not'.

Ex:  (perl-mode jargon-mode c-mode)	; just perl, C, and jargon modes
     (not text-mode)			; all modes except text mode")

(defvar hilit-auto-highlight-maxout 50000
  "auto-highlight is disabled in buffers larger than this")

(defvar hilit-auto-rehighlight 'visible
  "If this is non-nil, then hilit-redraw and hilit-recenter will also
  rehighlight part or all of the current buffer.  T will rehighlights the
  whole buffer, a NUMBER will rehighlight that many lines before and
  after the cursor, or the symbol 'visible' will rehighlight only the visible
  portion of the current buffer.")

(make-variable-buffer-local 'hilit-auto-rehighlight)
(setq-default hilit-auto-rehighlight 'visible)

(defvar hilit-auto-rehighlight-fallback 'visible
  "Value assigned to hilit-auto-rehighlight when automatic rehighlighting is
turned off in the buffer.") 

(defvar hilit-mode-alist nil
  "A-list of major-mode values and default highlighting patterns

A hilighting pattern is a list of the form (start end face), where
start is a regex, end is a regex (or nil if it's not needed) and face
is the name of an entry in hilit-face-translation-table, the name of a face,
or nil (which disables the pattern).

See hilit-face-translation-table hilit-lookup-face-create for valid face names.")

;; These faces are either a valid face name, or nil
;; if you want to change them, you must do so AFTER hilit19 is loaded

(defconst hilit-face-translation-table
  (if (and (x-display-color-p)
	   (not hilit-no-color))
      '(
	;; used for C/C++ and elisp and perl
	(comment	. firebrick-italic)
	(include	. purple)
	(define		. ForestGreen)
	(defun		. blue-bold)
	(decl		. RoyalBlue)
	(type		. nil)
	(keyword	. RoyalBlue)
	(label		. red-bold)
	(string		. grey40)

	;; some further faces for Ada
	(struct		. black-bold)
	(glob-struct	. magenta)
	(named-param	. DarkGoldenrod)
	
	;; and anotherone for LaTeX
	(crossref	. DarkGoldenrod)
 
	(wysiwyg-bold   . default-bold)
	(wysiwyg-underline . default-underline)

	;; compilation buffers
	(error		. red-bold)
	(warning	. firebrick)

	;; Makefiles (some faces borrowed from C/C++ too)
	(rule		. blue-bold)

	;; fundamental modes (shell-script comments if you enable them)
	(fund-comment	. firebrick-italic)

	;; VM, GNUS and Text mode
	(msg-subject	. blue-bold)
	(msg-header	. firebrick-bold)
	(msg-quote	. ForestGreen)

	(summary-seen	. grey50)
	(summary-killed	. grey50)
	(summary-Xed	. OliveDrab2)
	(summary-current . ForestGreen-bold-underline)
	(summary-deleted . red)
	(summary-unread	. purple)
	(summary-new	. blue-bold)

	(gnus-group-unsubscribed . grey50)
	(gnus-group-empty	. default)
	(gnus-group-full	. ForestGreen)
	(gnus-group-overflowing	. firebrick)

	;; see jargon-mode.el and prep.ai.mit.edu:/pub/gnu/jargon*.txt
	(jargon-entry		. blue-bold)
	(jargon-xref		. purple-bold) ; hex-00A011
	;; really used for Info-mode
	(jargon-keyword		. firebrick-underline)
	)
    '(
      ;; used for C/C++ and elisp and perl
      (comment       . default-italic)
      (include       . default-bold-italic)
      (define        . default-bold)
      (defun         . default-bold-italic)
      (decl          . default-bold)
      (type          . nil)
      (keyword       . default-bold-italic)
      (label         . default-underline)
      (string        . default-underline)

      ;; some further faces for Ada
      (struct	     . default-bold)
      (glob-struct   . default-bold-underline)
      (named-param   . default-underline)
      
      ;; and another one for LaTeX
      (crossref	     . default-underline)

      (wysiwyg-bold  . default-bold)
      (wysiwyg-underline . default-underline)

      ;; compilation buffers
      (error         . default-bold)
      (warning       . default-italic)

      ;; Makefiles (some faces borrowed from C/C++ too)
      (rule          . default-bold)

      ;; fundamental modes (shell-script comments if you enable them)
      (fund-comment  . default-italic)

      ;; VM, GNUS and Text mode
      (msg-subject   . default-bold)
      (msg-header    . default-italic)
      (msg-quote     . default-italic)

      (summary-seen	. default)
      (summary-killed	. default)
      (summary-Xed	. default)
      (summary-current	. reverse-default)
      (summary-unread	. default-bold)
      (summary-deleted	. default-italic)
      (summary-new	. default-bold-italic)

      (gnus-group-unsubscribed	. default)
      (gnus-group-empty		. default)
      (gnus-group-full		. default-italic)
      (gnus-group-overflowing	. default-bold-italic)

      ;; see jargon-mode.el and prep.ai.mit.edu:/pub/gnu/jargon*.txt
      (jargon-entry		. default-bold)
      (jargon-xref		. default-italic)
      ;; really used for Info-mode
      (jargon-keyword		. default-underline) ))
    "alist that maps symbolic face-names to real face names")

(defun hilit-lookup-face-create (face &optional force)
  "Get a FACE, or create it if it doesn't exist.  In order for it to
properly create the face, the followwing naming convention must be used:
    [reverse[-]](default|color|hex-[0-9A-Fa-f]+)[-bold][-italic][-underline]
Example: (hilit-lookup-face-create 'comment-face) might create and return 'red

An optional argument, FORCE, will cause the face to be recopied from the
default...which is probably of use only if you've changed fonts."

  (let ((trec (assoc face hilit-face-translation-table)))
    (and trec (setq face (cdr trec))))
  (or (not face)
      (and (not force) (memq face (face-list)))
      (let ((fn (symbol-name face))
	    color error)
	(copy-face 'default 'scratch-face)
	(if (string-match "^reverse-?" fn)
	    (progn (invert-face 'scratch-face)
		   (setq fn (substring fn (match-end 0)))))
	(if (string-match "^hex-\\([0-9A-Za-z]+\\)" fn)
	    (setq fn (concat "#" (substring fn (match-beginning 1)))))
	(string-match "^#?[A-Za-z0-9]+" fn)
	(setq color (substring fn 0 (match-end 0)))
	(cond ((string= color "default") nil)
	      (t (condition-case nil
		     (set-face-foreground 'scratch-face color)
		   (error (message "Warning: couldn't allocate color for '%s'"
				   (symbol-name face))
			  (ding) (sit-for 2)
			  (setq face 'default)
			  (setq error t)))))
	;; this hacks around a bug in faces.el (remove it in the future)
	(condition-case nil
	    (progn 
	      (if (string-match ".*bold" fn)
		  (make-face-bold 'scratch-face nil 'noerr))
	      (if (string-match ".*italic" fn)
		  (make-face-italic 'scratch-face nil 'noerr)))
	  (error nil))
	(set-face-underline-p 'scratch-face (string-match "-underline" fn))
	(or error (copy-face 'scratch-face face))))
  face)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Region Highlight/Unhighlight code (Both overlay and text-property versions)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defsubst hilit-region-set-face (start end face-name &optional prio prop)
  "Highlight region from START to END using FACE and, optionally, PRIO.
The optional 5th arg, PROP is a property to set instead of 'hilit."
  (let ((overlay (make-overlay start end)))
    (overlay-put overlay 'face face-name)
    (overlay-put overlay (or prop 'hilit) t)
    (and prio (overlay-put overlay 'priority prio))))

(defun hilit-unhighlight-region (start end &optional quietly)
  "Unhighlights the region from START to END, optionally in a QUIET way"
  (interactive "r")
  (or quietly hilit-quietly (message "Unhighlighting"))
  (while (< start end)
    (mapcar '(lambda (ovr)
	       (and (overlay-get ovr 'hilit) (delete-overlay ovr)))
	    (overlays-at start))
    (setq start (next-overlay-change start)))
  (or quietly hilit-quietly (message "Done unhighlighting")))

;;;; These functions use text properties instead of overlays.  Text properties
;;;; are copied through kill and yank...which might be convenient, but is not
;;;; terribly efficient as of 19.12, ERGO it's been disabled
;;
;;(defsubst hilit-region-set-face (start end face-name &optional prio prop)
;;  "Highlight region from START to END using FACE and, optionally, PRIO.
;;The optional 5th arg, PROP is a property to set instead of 'hilit."
;;    (put-text-property start end 'face face-name)
;;    )
;;
;;(defun hilit-unhighlight-region (start end &optional quietly)
;;  "Unhighlights the region from START to END, optionally in a QUIET way"
;;  (interactive "r")
;;  (let ((buffer-read-only nil)
;;	(bm (buffer-modified-p)))
;;    (remove-text-properties start end '(face))
;;    (set-buffer-modified-p bm)))
;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Pattern Application code and user functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun hilit-highlight-region (start end &optional patterns quietly)
  "Highlights the area of the buffer between START and END (the region when
interactive).  Without the optional PATTERNS argument, the pattern for
major-mode is used.  If PATTERNS is a symbol, then the patterns associated
with that symbol are used.  QUIETLY suppresses progress messages if
non-nil."
  (interactive "r")
  (cond ((null patterns)
	 (setq patterns (cdr (assoc major-mode hilit-mode-alist))))
	((symbolp patterns)
	 (setq patterns (cdr (assoc patterns hilit-mode-alist)))))  
  ;; txt prop: (setq patterns (reverse patterns))
  (let ((prio (length patterns))
	(case-fold-search t)
	;; txt prop: (buffer-read-only nil)
	;; txt prop: (bm (buffer-modified-p))
	p pstart pend face mstart)
    ;; txt prop: (unwind-protect
    (save-excursion
      (save-restriction
	(narrow-to-region start end)
	(while patterns
	  (setq p (car patterns))
	  (setq pstart (car p)
		pend (nth 1 p)
		face (hilit-lookup-face-create (nth 2 p)))
	  (if (not face)		; skipped if nil
	      nil
	    (or quietly hilit-quietly
		(message "highlighting %d: %s%s" prio pstart 
			 (if pend (concat " ... " pend) "")))
	    (goto-char (point-min))
	    (condition-case nil
		(cond 
		      ((symbolp pstart)
		       ;; inner loop -- special function to find pattern
		       (let (reg)
			 (while (setq reg (funcall pstart pend))
			   (hilit-region-set-face (car reg) (cdr reg)
						  face prio))))
		      (pend
		       ;; inner loop -- regex-start ... regex-end
		       (while (re-search-forward pstart nil t nil)
			 (goto-char (setq mstart (match-beginning 0)))
			 (if (re-search-forward pend nil t nil)
			     (hilit-region-set-face mstart (match-end 0)
						    face prio)
			   (forward-char 1))))
		      (t
		       ;; inner loop -- just one regex to match whole pattern
		       (while (re-search-forward pstart nil t nil)
			 (hilit-region-set-face  (match-beginning 0)
						 (match-end 0) face prio))))
	      (error (message "Unbalanced delimiters?  Barfed on '%s'"
			      pstart)
		     (ding) (sit-for 4))))
	  (setq prio (1- prio)
		patterns (cdr patterns)))
	))				
    (or quietly hilit-quietly (message "Done highlighting"))
    ;; txt prop: (set-buffer-modified-p bm)) ; unwind protection
    ))

(defun hilit-rehighlight-region (start end &optional quietly)
  "Re-highlights the region, optionally in a QUIET way"
  (interactive "r")
  (hilit-unhighlight-region start end quietly)
  (hilit-highlight-region   start end nil quietly))

(defun hilit-rehighlight-buffer (&optional quietly)
  "Re-highlights the buffer, optionally in a QUIET way"
  (interactive "")
  (hilit-rehighlight-region (point-min) (point-max) quietly)
  nil)

(defalias 'hilit-highlight-buffer 'hilit-rehighlight-buffer)

(defun hilit-toggle-highlight (arg)
  "Locally toggle highlighting.  With arg, forces highlighting off."
  (interactive "P")
  ;; FIXME -- this loses numeric information in hilit-auto-rehighlight
  (setq hilit-auto-rehighlight
	(and (not arg) (not hilit-auto-rehighlight)))
  (if hilit-auto-rehighlight
      (hilit-rehighlight-buffer)
    (hilit-unhighlight-region (point-min) (point-max)))
  (message "Rehighlighting is set to %s" hilit-auto-rehighlight))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HOOKS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun hilit-highlight-after-find ()
  "Find-file hook for hilit package.  See the variable hilit-auto-highlight."
  (and hilit-auto-highlight		; do we want to highlight this?
       (or (not (consp hilit-auto-highlight)) 
	   (if (eq 'not (car hilit-auto-highlight))
	       (not (memq major-mode (cdr hilit-auto-highlight)))
	     (memq major-mode hilit-auto-highlight)))
       (assoc major-mode hilit-mode-alist) ; do we know how to highlight it?
       (if (> buffer-saved-size hilit-auto-highlight-maxout)
	   (progn
	     (or hilit-quietly
		 (message "This buffer is large, highlight it yourself"))
	     (setq hilit-auto-rehighlight hilit-auto-rehighlight-fallback))
	 (hilit-rehighlight-buffer)
	 (set-buffer-modified-p nil))))

(defun hilit-rehighlight-buffer-quietly ()
  (hilit-rehighlight-buffer t))

(defun hilit-rehighlight-message-quietly ()
  "Highlight a buffer containing a news article or mail message."
  (goto-char (point-min))
  (re-search-forward "^$" nil 'noerr)
  (hilit-highlight-region (point-min) (point) 'msg-header t)
  (hilit-highlight-region (point) (point-max) 'msg-body t))   

(defun hilit-redraw-internal (force &rest hooks)
  (cond (force
	 (hilit-rehighlight-buffer))
	((eq  hilit-auto-rehighlight 'visible)
	 (hilit-rehighlight-region (window-start) (window-end) 'quietly))
        ((numberp hilit-auto-rehighlight)
         (let ((start (save-excursion
			(forward-line (- hilit-auto-rehighlight))
			(point)))
               (end   (save-excursion
			(forward-line hilit-auto-rehighlight)
			(point))))
           (hilit-rehighlight-region start end)))
        (hilit-auto-rehighlight
	 (hilit-rehighlight-buffer)))
  (run-hooks 'hooks))

(defun hilit-recenter (arg)
  "Recenter, then rehighlight according to hilit-auto-rehighlight.  If called
with an unspecified prefix argument (^U but no number), then a rehighlight of
the entire buffer is forced."
  (interactive "P")
  (recenter arg)
  (sit-for 0) ; force display update to avoid having to stare at a blank screen
  (hilit-redraw-internal (consp arg)))

(defun hilit-redraw-display (arg)
  "Rehighlights the buffer if called with a prefix arg, or if
(eval hilit-auto-rehighlight) is non-nil.  Otherwise just like redraw-display."
  (interactive "P")
  (hilit-redraw-internal arg 'redraw-display))

(defun hilit-rehighlight-yank-region ()
  "Rehighlights from the beginning of the line where the region starts to
the end of the line where the region ends.  This could flake out on
multi-line highlights (like C comments and lisp strings.)"
  (if hilit-auto-rehighlight
      (hilit-rehighlight-region
       (save-excursion (goto-char (region-beginning))
		       (beginning-of-line) (point))
       (save-excursion (goto-char (region-end))
		       (end-of-line) (point))
       t)))

(defun hilit-yank (arg)
  "Yank with rehighlighting"
  (interactive "*P")
  (let ((transient-mark-mode nil))
    (yank arg)
    (hilit-rehighlight-yank-region)
    (setq this-command 'yank)))

(defun hilit-yank-pop (arg)
  "Yank-pop with rehighlighting"
  (interactive "*p")
  (let ((transient-mark-mode nil))
    (yank-pop arg)
    (hilit-rehighlight-yank-region)
    (setq this-command 'yank)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Wysiwyg Stuff...  take it away and build a whole package around it!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; For the Jargon-impaired, WYSIWYG === What You See Is What You Get
; Sure, it sucks to type.  Oh, well.
(defun hilit-wysiwyg-replace ()
  "Replace overstruck text with normal text that's been overlayed with the 
appropriate text attribute.  Suitable for a find-file hook."
  (save-excursion
    (goto-char (point-min))
    (let ((wysb (hilit-lookup-face-create 'wysiwyg-bold))
	  (wysu (hilit-lookup-face-create 'wysiwyg-underline))
	  (bmod (buffer-modified-p)))
      (while (re-search-forward "\\(.\b.\\)+" nil t)
	(let ((st (match-beginning 0)) (en (match-end 0)))
	  (goto-char st)
	  (if (looking-at "_")
	      (hilit-region-set-face st en wysu 100 'wysiwyg)
	    (hilit-region-set-face st en wysb 100 'wysiwyg))
	  (while (and (< (point) en) (looking-at ".\b"))
	    (replace-match "") (forward-char))
	  ))
      (set-buffer-modified-p bmod))))

; is this more appropriate as a write-file-hook or a write-contents-hook?
(defun hilit-wysiwyg-write-repair ()
  "Replace wysiwyg overlays with overstrike text."
  (message "*sigh* hilit-wysiwyg-write-repair not implemented yet")
;;
;; For efficiency, this hook should copy the current buffer to a scratch
;; buffer and do it's overstriking there.  Overlays are not copied, so it'll
;; be necessary to hop back and forth.  This is OK since you're not fiddling
;; with--making or deleting--any overlays.  THEN write the new buffer,
;; delete it, and RETURN T. << important
;;
;; Just so you know...there is already an emacs function called
;; underline-region that does underlining.  I think that the thing to do is
;; extend that to do overstriking as well.
;;
;;  (while (< start end)
;;    (mapcar '(lambda (ovr)
;;	       (and (overlay-get ovr 'hilit) (delete-overlay ovr)))
;;	    (overlays-at start))
;;    (setq start (next-overlay-change start)))
  nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initialization.  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(substitute-key-definition 'yank     'hilit-yank     (current-global-map))
(substitute-key-definition 'yank-pop 'hilit-yank-pop (current-global-map))

(substitute-key-definition 'recenter 'hilit-recenter (current-global-map))
(substitute-key-definition 'redraw-display 'hilit-redraw-display
			   (current-global-map))

(if hilit-inhibit-hooks
    nil
  (condition-case c
      (progn
	(add-hook 'find-file-hooks 'hilit-highlight-after-find t)

	;; This will work when the patch propagates
	(add-hook 'Info-select-hook
		  'hilit-rehighlight-buffer-quietly)

	;; I know not for which version of VM these work...
	(add-hook 'vm-summary-mode-hook
		  'hilit-rehighlight-buffer-quietly)
	(add-hook 'vm-preview-message-hook
		  'hilit-rehighlight-message-quietly)
	(add-hook 'vm-show-message-hook
		  'hilit-rehighlight-message-quietly)
	(add-hook 'vm-summary-pointer-hook
		  'hilit-rehighlight-buffer-quietly)

	(add-hook 'gnus-summary-prepare-hook
		  'hilit-rehighlight-buffer-quietly)
	(add-hook 'gnus-article-prepare-hook
		  'hilit-rehighlight-message-quietly)
	(add-hook 'rmail-show-message-hook
		  'hilit-rehighlight-message-quietly)

	(add-hook 'gnus-group-prepare-hook 'hilit-rehighlight-buffer-quietly)

        ;; rehilight only the visible part of the summary buffer for speed.
        (add-hook 'gnus-mark-article-hook
                  '(lambda ()
                     (gnus-summary-mark-as-read gnus-current-article)
                     (gnus-summary-set-current-mark)
                     (save-excursion
                       (set-buffer gnus-summary-buffer)
                       (hilit-rehighlight-region (window-start) (window-end) t)
                       )))
;; only need prepare article hook
;;
;;	(add-hook 'gnus-select-article-hook
;;		  '(lambda () (save-excursion
;;				(set-buffer gnus-article-buffer)
;;				(hilit-rehighlight-buffer))))
	)
    (error (message "Error loading highlight hooks: %s" c)
	   (ding) (sit-for 5))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Default patterns for various modes.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun hilit-associate (alist key val)
  "creates, or destructively replaces, the pair (key . val) in alist"
  (let ((oldentry (assoc key (eval alist))))
    (if oldentry
	(setcdr oldentry val)
      (set alist (cons (cons key val) (eval alist))))))
  
(defun hilit-translate (from to)
  "Translate one face to another.  hilit-lookup-face-create does only one
translation, so this must be the name of the face as it appears in
hilit-mode-alist."
  (interactive "SFace translate from: \nSFace translate to: ")
  (hilit-associate 'hilit-face-translation-table from to))

(defun hilit-set-mode-patterns (mode patterns)
  "Sets the default hilighting patterns for MODE to PATTERNS"
  (hilit-associate 'hilit-mode-alist mode patterns))

(defun hilit-string-find (qchar)
  "looks for a string and returns (start . end) or NIL.  The argument QCHAR
is the character that would precede a character constant double quote.
Finds  [^QCHAR]\" ... [^\\]\""
  (let (st en)
    (while (and (search-forward "\"" nil t)
		(eq qchar (char-after (1- (setq st (match-beginning 0)))))))
    (while (and (search-forward "\"" nil t)
		(eq ?\\ (char-after (- (setq en (point)) 2)))))
    (and en (cons st en))))    

(let ((c-mode-highlight
      '(("/\\*" "\\*/" comment)
;	("\"" "[^\\]\"" string)
	(hilit-string-find ?' string)
	;; declaration
	("^#[ \t]*define.*$" nil define)
	("^#.*$" nil include)
	;; function decls are expected to have types on the previous line
	("^\\(\\w\\|[$_]\\)+\\s *\\(\\(\\w\\|[$_]\\)+\\s *((\\|(\\)[^)]*)" nil defun)
	("^\\(typedef\\|struct\\|union\\|enum\\).*$" nil decl)
	;; datatype -- black magic regular expression
	("[ \n\t({]\\(\\(register\\|volatile\\|unsigned\\|extern\\|static\\)\\s +\\)*\\(\\(\\w\\|[$_]\\)+_t\\|float\\|double\\|void\\|char\\|short\\|int\\|long\\|FILE\\|\\(\\(struct\\|union\\|enum\\)\\([ \t]+\\(\\w\\|[$_]\\)*\\)\\)\\)\\(\\s +\\*+)?\\|[ \n\t;()]\\)" nil type)
	;; key words
	("\\<\\(return\\|goto\\|if\\|else\\|case\\|default:\\|switch\\|break\\|continue\\|while\\|do\\|for\\)\\>" nil keyword)
	)))
  (hilit-set-mode-patterns 'c-mode c-mode-highlight)
  (hilit-set-mode-patterns 'c++-c-mode c-mode-highlight)
  (hilit-set-mode-patterns 'elec-c-mode c-mode-highlight))

(hilit-set-mode-patterns
 'c++-mode
 '(("/\\*" "\\*/" comment)
   ("//.*$" nil comment)
   ("^/.*$" nil comment)
;   ("\"" "[^\\]\"" string)
   (hilit-string-find ?' string)
   ;; declaration	
   ("^#[ \t]*define.*$" nil define)
   ("^#.*$" nil include)
   ;; function decls are expected to have types on the previous line
   ("^\\(\\w\\|[$_]\\)+\\s *\\(\\(\\w\\|[$_]\\)+\\s *((\\|(\\)[^)]*)" nil defun)
   ("^\\(template\\|typedef\\|struct\\|union\\|class\\|enum\\|public\\|private\\|protected\\).*$" nil decl)
   ;; datatype -- black magic regular expression
   ("[ \n\t({]\\(\\(register\\|volatile\\|unsigned\\|extern\\|static\\)\\s +\\)*\\(\\(\\w\\|[$_]\\)+_t\\|float\\|double\\|void\\|char\\|short\\|int\\|long\\|FILE\\|\\(\\(struct\\|union\\|enum\\)\\([ \t]+\\(\\w\\|[$_]\\)*\\)\\)\\)\\(\\s +\\*+)?\\|[ \n\t;()]\\)" nil type)
   ;; key words
   ("\\<\\(return\\|goto\\|if\\|else\\|case\\|default:\\|switch\\|break\\|continue\\|while\\|do\\|for\\)\\>" nil keyword)))

(hilit-set-mode-patterns
 'perl-mode
 '(("\\s #.*$" nil comment)
   ("^#.*$" nil comment)
   ("\"[^\\\"]*\\(\\\\\\(.\\|\n\\)[^\\\"]*\\)*\"" nil string)
   ("^\\(__....?__\\|\\s *\\sw+:\\)" nil label)
   ("^require.*$" nil include)
   ("^package.*$" nil decl)
   ("^\\s *sub\\s +\\(\\w\\|[_']\\)+" nil defun)
   ("\\b\\(do\\|if\\|unless\\|while\\|until\\|else\\|elsif\\|for\\|foreach\\|continue\\|next\\|redo\\|last\\|goto\\|return\\|die\\|exit\\)\\b" nil keyword)))

(hilit-set-mode-patterns
 'prolog-mode
 '(("/\\*" "\\*/" comment)
   ("%.*$" nil comment)
   (":-" nil defun)
   ("!" nil label)
   ("\"[^\\\"]*\\(\\\\\\(.\\|\n\\)[^\\\"]*\\)*\"" nil string)
   ("\\b\\(is\\|mod\\)\\b" nil keyword)
   ("\\(->\\|-->\\|;\\|==\\|\\\\==\\|=<\\|>=\\|<\\|>\\|=\\|\\\\=\\|=:=\\|=\\\.\\\.\\|\\\\\\\+\\)" nil decl)
   ("\\(\\\[\\||\\|\\\]\\)" nil include)
   ))

(hilit-set-mode-patterns
 'ada-mode
 '(;; comments
   ("--.*$" nil comment)

   ;; main structure
   ("[ \t\n]procedure[ \t]" "\\([ \t]\\(is\\|renames\\)\\|);\\)" glob-struct)
   ("[ \t\n]task[ \t]" "[ \t]is" glob-struct)
   ("[ \t\n]function[ \t]" "return[ \t]+[A-Z_0-9]+[ \t]*\\(is\\|;\\|renames\\)" glob-struct)
   ("[ \t\n]package[ \t]" "[ \t]\\(is\\|renames\\)" glob-struct)

   ;; if there is no indentation before the "end", then it is most
   ;; probably the end of the package
   ("^end.*$" ";" glob-struct)

   ;; program structure -- "null", "delay" and "terminate" omitted
   ("[ \n\t]\\(in\\|out\\|select\\|if\\|else\\|case\\|when\\|and\\|or\\|not\\|accept\\|loop\\|do\\|then\\|elsif\\|else\\|for\\|while\\|exit\\)[ \n\t;]" nil struct)
 
   ;; block structure
   ("[ \n\t]\\(begin\\|end\\|declare\\|exception\\|generic\\|raise\\|return\\|package\\|body\\)[ \n\t;]" nil struct)

   ;; type declaration
   ("^[ \t]*\\(type\\|subtype\\).*$" ";" decl)
   ("[ \t]+is record.*$" "end record;" decl)

   ;; "pragma", "with", and "use" is close to C cpp directives
   ("^[ \t]*\\(with\\|pragma\\|use\\)" ";" include)

   ;; this is nice for named parameters, but not so beautyful
   ;; in case statements
   ("[A-Z_0-9.]+[ \t]*=>"   nil named-param)

   ;; string constants
   ;; probably not everybody likes this one
   ("\"" ".*\"" string)))

(let ((LaTeX-mode-patterns
       '(
	 ;; comments
	 ("%.*$" nil comment)

	 ;; the following two match \foo[xx]{xx} or \foo*{xx} or \foo{xx}
	 ("\\\\\\(sub\\)*\\(paragraph\\|section\\)\\(\*\\|\\[.*\\]\\)?{" "}"
	  keyword)
	 ("\\\\\\(chapter\\|part\\)\\(\*\\|\\[.*\\]\\)?{" "}" keyword)
	 ("\\\\footnote\\(mark\\|text\\)?{" "}" keyword)
	 ("\\\\[a-z]+box" nil keyword)
	 ("\\\\\\(v\\|h\\)space\\(\*\\)?{" "}" keyword)

	 ;; (re-)define new commands/environments/counters
	 ("\\\\\\(re\\)?new\\(environment\\|command\\){" "}" defun)
	 ("\\\\new\\(length\\|theorem\\|counter\\){" "}" defun)

	 ;; various declarations/definitions
	 ("\\\\\\(setlength\\|settowidth\\|addtolength\\|setcounter\\|addtocounter\\)" nil define)
	 ("\\\\\\(\\|title\\|author\\|date\\|thanks\\){" "}" define)

	 ("\\\\documentstyle\\(\\[.*\\]\\)?{" "}" decl)
	 ("\\\\\\(begin\\|end\\|nofiles\\|includeonly\\){" "}" decl)
	 ("\\\\\\(raggedright\\|makeindex\\|makeglossary\\|maketitle\\)\\b" nil
	  decl)
	 ("\\\\\\(pagestyle\\|thispagestyle\\|pagenumbering\\){" "}" decl)
	 ("\\\\\\(normalsize\\|small\\|footnotesize\\|scriptsize\\|tiny\\|large\\|Large\\|LARGE\\|huge\\|Huge\\)\\b" nil decl)
	 ("\\\\\\(appendix\\|tableofcontents\\|listoffigures\\|listoftables\\)\\b"
	  nil decl)
	 ("\\\\\\(bf\\|em\\|it\\|rm\\|sf\\|sl\\|ss\\|tt\\)\\b" nil decl)

	 ;; label-like things
	 ("\\\\item\\[" "\\]" label)
	 ("\\\\item\\b" nil label)
	 ("\\\\caption\\(\\[.*\\]\\)?{" "}" label)

	 ;; things that bring in external files
	 ("\\\\\\(include\\|input\\|bibliography\\){" "}" include)

	 ("``" "''" string)

	 ;; things that do some sort of cross-reference
	 ("\\\\\\(\\(no\\)?cite\\|\\(page\\)?ref\\|label\\|index\\|glossary\\){" "}"
	  crossref)
	 )))
  (hilit-set-mode-patterns 'LaTeX-mode LaTeX-mode-patterns)
  (hilit-set-mode-patterns 'japanese-LaTeX-mode LaTeX-mode-patterns)
  (hilit-set-mode-patterns 'SliTeX-mode LaTeX-mode-patterns)
  (hilit-set-mode-patterns 'japanese-SliTeX-mode LaTeX-mode-patterns)
  (hilit-set-mode-patterns 'FoilTeX-mode LaTeX-mode-patterns)
  (hilit-set-mode-patterns 'latex-mode LaTeX-mode-patterns))

(hilit-set-mode-patterns
 'compilation-mode
 '(("^[^ \t]*:[0-9]+:.*$" nil error)
   ("^[^ \t]*:[0-9]+: warning:.*$" nil warning)))

(hilit-set-mode-patterns
 'timecard-mode
 '(("^../..:\\s +..... - ..:.." nil purple)
   ("^-------*" nil red-italic)
   ("^../..\\s +[[].*$" nil ForestGreen)))

;(hilit-set-mode-patterns
; 'fundamental-mode
; '(("^#.*$" nil fund-comment)
;   ("[^$]#.*$" nil fund-comment)))

(hilit-set-mode-patterns
 'makefile-mode
 '(("^#.*$" nil comment)
   ("[^$]#.*$" nil comment)
   ;; rules
   ("^%.*$" nil rule)
   ("^[.][A-Z][A-Z]?\..*$" nil rule)
   ;; variable definition
   ("^[_A-Z0-9]+ *\+?=" nil define)
   ("\\( \\|:=\\)[_A-Z0-9]+ *\\+=" nil define)
   ;; variable references
   ("\$[_A-Z0-9]" nil type)
   ("\${[_A-Z0-9]+}" nil type)
   ("\$\([_A-Z0-9]+\)" nil type)
   ("^include " nil include)))

(let* ((header-patterns '(("^Subject:.*$" nil msg-subject)
			  ("^[A-Z][A-Z0-9-]+:" nil msg-header)))
       (body-patterns '(("^\\(In artic\\|[ \t]*\\w* *[]>}|]\\).*$" msg-quote)))
       (message-patterns (append header-patterns body-patterns)))
  (hilit-set-mode-patterns 'msg-header header-patterns)
  (hilit-set-mode-patterns 'msg-body body-patterns)
  (hilit-set-mode-patterns 'vm-mode message-patterns)
  (hilit-set-mode-patterns 'text-mode message-patterns)
  (hilit-set-mode-patterns 'mail-mode message-patterns)
  (hilit-set-mode-patterns 'rmail-mode message-patterns)
  (hilit-set-mode-patterns 'gnus-article-mode message-patterns)
  )

(hilit-set-mode-patterns
 'gnus-group-mode
 '(("^U.*$" nil gnus-group-unsubscribed)
   ("^ +[0-9]:.*$" nil gnus-group-empty)
   ("^ +[0-9][0-9]:.*$" nil gnus-group-full)
   ("^ +[0-9][0-9][0-9]+:.*$" nil gnus-group-overflowing)))

(hilit-set-mode-patterns
 'gnus-summary-mode
 '(("^D +[0-9]+: \\[.*$" nil summary-seen)
   ("^K +[0-9]+: \\[.*$" nil summary-killed)
   ("^X +[0-9]+: \\[.*$" nil summary-Xed)
   ("^- +[0-9]+: \\[.*$" nil summary-unread)
   ("^. +[0-9]+:\\+\\[.*$" nil summary-current)
   ("^  +[0-9]+: \\[.*$" nil summary-new)
   ))

(hilit-set-mode-patterns
 'vm-summary-mode
 '(("^   .*$" nil summary-seen)
   ("^->.*$" nil  summary-current)
   ("^  D.*$" nil summary-deleted)
   ("^  U.*$" nil summary-unread)
   ("^  N.*$" nil summary-new)))

(hilit-set-mode-patterns
 'emacs-lisp-mode
 '(("^;.*$" nil comment)
   ("\\s ;+[ ;].*$" nil comment)
; this string expression barfs on really long strings
;   ("\"[^\\\"]*\\(\\\\\\(.\\|\n\\)[^\\\"]*\\)*\"" nil string)
;   ("\"" "[^\\]\"" string) ; barfs on double-quote character constants
   (hilit-string-find ?\\ string)
   ("^\\s *(\\(defun\\|defmacro\\|defsubst\\)\\s " ")" defun)
   ("^\\s *(defvar\\s +\\S +" nil decl)
   ("^\\s *(defconst\\s +\\S +" nil define)
   ("^\\s *(\\(provide\\|require\\|load\\).*$" nil include)))

(hilit-set-mode-patterns
 'plain-tex-mode
 '(("^%%.*$" nil comment)
   ("{\\\\em\\([^}]+\\)}" nil comment)
   ("\\(\\\\\\w+\\)" nil keyword)
   ("{\\\\bf\\([^}]+\\)}" nil keyword)
   ("^[ \t\n]*\\\\def[\\\\@]\\(\\w+\\)" nil defun)
   ("\\\\\\(begin\\|end\\){\\([A-Z0-9\\*]+\\)}" nil defun)
;   ("[^\\\\]\\$\\([^$]*\\)\\$" nil string)
   ("\\$\\([^$]*\\)\\$" nil string)
   ))

;; Reasonable extensions would include smarter parameter handling for such
;; things as the .IX and .I macros, which alternate the handling of following
;; arguments.

(hilit-set-mode-patterns
 'nroff-mode
 '(("^\\.[\\\][\\\"].*$" nil comment)
   ("^\\.so .*$" nil include)
   ("^\\.[ST]H.*$" nil defun)
   ("^[^\\.].*\"[^\\\"]*\\(\\\\\\(.\\)[^\\\"]*\\)*\"" nil string)
   ("^\\.[A-Z12\\\\].*$" nil define)
   ("\\([\\\][^ ]*\\)" nil keyword)
   ("^\\.[a-z].*$" nil keyword)))

(hilit-set-mode-patterns
 'texinfo-mode
 '(("^\\(@c\\|@comment\\)\\>.*$" nil comment)
   ("@\\(emph\\|strong\\|b\\|i\\){[^}]+}" nil comment)
; seems broken
;   ("\\$[^$]*\\$" nil string)
   ("@\\(file\\|kbd\\|key\\){[^}]+}" nil string)
   ("^\\*.*$" nil defun)
   ("@\\(if\\w+\\|format\\|item\\)\\b.*$" nil defun)
   ("@end +[A-Z0-9]+[ \t]*$" nil defun)
   ("@\\(samp\\|code\\|var\\){[^}]+}" nil defun)
;   ("@\\(@\\|[^}\t \n{]+\\)" nil keyword)
;   ("@\\w+" nil keyword)
   ("@\\w+\\({[^}]+}\\)?" nil keyword)
   ))

(hilit-set-mode-patterns
 'jargon-mode
 '(("^:[^:]*:" nil jargon-entry)
   ("{[^}]*}+" nil jargon-xref)))

(hilit-set-mode-patterns
 'Info-mode
 '(("^\\* [^:]+:+\\( ([^)]+)\\.\\)?" nil jargon-entry)
   ("\\*[Nn]ote [^:]+:+" nil jargon-xref)
   ("- \\(Variable\\|Function\\|Command\\):.*$" nil jargon-keyword)))

(provide 'hilit19)



;; ____________________________________________________________________________
;; Stig@netcom.com                              netcom.com:/pub/stig/00-PGP-KEY
;; It's hard to be cutting-edge at your own pace...     32 DF B9 19 AE 28 D1 7A
;; Another Enemy of the State -- Vote Anarchist!	A3 9D 0B 1A 33 13 4D 7F

