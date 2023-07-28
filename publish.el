;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")))

;; Initialize the package system
(package-initialize)
;; (unless package-archive-contents
;; (package-refresh-contents))
(package-refresh-contents)

;; ;; Install dependencies
(package-install 'htmlize)
(package-install 'org)
(package-install 'org-roam)

;; Load the publishing system
(require 'ox-publish)
(require 'org-roam)

(setq org-roam-directory (file-truename "./org"))
(setq org-id-link-to-org-use-id t)
;; (org-roam-db-autosync-mode)

(setq org-id-extra-files (org-roam-list-files))

(defun org-html--reference (datum info &optional named-only)
  "Return an appropriate reference for DATUM.

DATUM is an element or a `target' type object.  INFO is the
current export state, as a plist.

When NAMED-ONLY is non-nil and DATUM has no NAME keyword, return
nil.  This doesn't apply to headlines, inline tasks, radio
targets and targets."
  (let* ((type (org-element-type datum))
	 (user-label
	  (org-element-property
	   (pcase type
	     ((or `headline `inlinetask) :CUSTOM_ID)
	     ((or `radio-target `target) :value)
	     (_ :name))
	   datum))
         (user-label (or user-label
                         (when-let ((path (org-element-property :ID datum)))
                           (concat "ID-" path)))))
    (cond
     ((and user-label
	   (or (plist-get info :html-prefer-user-labels)
	       ;; Used CUSTOM_ID property unconditionally.
	       (memq type '(headline inlinetask))))
      user-label)
     ((and named-only
	   (not (memq type '(headline inlinetask radio-target target)))
	   (not user-label))
      nil)
     (t
      (org-export-get-reference datum info)))))


;; Customize the HTML output
(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />")


;; (setq org-link-search-must-match-exact-headline nil)
;; (setq org-id-track-globally t)

;; Define the publishing project
(setq org-publish-project-alist
      (list
       (list "org-site:main"
             :recursive t
             :exclude ".*dir-locals\.el|.*gitignore|*.gitmodules|.*/gtd/.*|.*/dailies/.*"
             :base-directory "./org"
	     :base-extension "org"
             :publishing-function 'org-html-publish-to-html
             :publishing-directory "./public"
	     
	     ;; CONFIGURATION
             :with-author nil           ;; Don't include author name
             :with-creator t            ;; Include Emacs and Org versions in footer
             :with-toc nil              ;; Include a table of contents
             :section-numbers nil       ;; Don't include section numbers
	     :headline-levels 4         ;; TUTORIAL
	     :auto-preamble nil         ;; IDK
             :time-stamp-file nil
             :auto-sitemap t)))

(setq org-export-with-broken-links 'mark)
;; Generate the site output
(org-publish-all t)

(message "Build complete!")
