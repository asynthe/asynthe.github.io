;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

;; Load the publishing system
(require 'ox-publish)

;; Customize the HTML output
(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      ;org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />"

      ; readtheorg theme
      org-safe-remote-resources '("https://fniessen.github.io/org-html-themes/org/theme-readtheorg.setup"))


;; Define the publishing project
(setq org-publish-project-alist
      '(
        ("org-notes"
         :recursive t
         :base-directory "./org"
         :publishing-directory "./public"
         :publishing-function org-html-publish-to-html
         
	     ;; Settings
         :with-author nil           ;; Don't include author name
         :with-creator t            ;; Include Emacs and Org versions in footer
         :with-toc t                ;; Include a table of contents
         :section-numbers nil       ;; Don't include section numbers
         :time-stamp-file nil)      ;; Don't include time stamp in expand-file-name
	
        ("org-static"
         :recursive t
         :base-directory "./org"
         :publishing-directory "./public"
         :publishing-function org-publish-attachment
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf")
        ("org" :components ("org-notes" "org-static"))))

;; Generate the site output
(org-publish-all t)

(message "Build complete!")
