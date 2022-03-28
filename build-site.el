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
      org-html-htmlize-output-type 'css        ;; Syntax highlighting
      org-html-head "<link rel=\"stylesheet\" href=\"/css/org.css\" /> <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css\">")

;; Define the publishing project
(setq org-publish-project-alist
      `(("home"
         :base-directory "."
         :publishing-function org-html-publish-to-html
         :publishing-directory "./public"
         :with-author nil
         :with-date nil
         :with-creator t
         :with-toc nil
         :section-numbers nil
         :time-stamp-file nil)

        ("notes"
         :auto-sitemap t
         :sitemap-sort-files anti-chronologically
         :sitemap-filename "index.org"
         :sitemap-title "Notes"
         :sitemap-function (lambda (title list)
                             (format "#+title: %s\n#+html_link_home: /\n#+html_link_up: /\n\n%s" title  (string-join (mapcar (lambda (el) (format "- %s" (car el))) (cdr list)) "\n")))
         :base-directory "./notes/"
         :publishing-function org-html-publish-to-html
         :publishing-directory "./public/notes/"
         :with-author nil
         :with-date t
         :with-creator t
         :with-toc t
         :section-numbers nil
         :time-stamp-file nil)

        ("images"
         :base-directory "./images/"
         :base-extension "jpeg\\|jpg\\|gif\\|png"
         :publishing-directory "./public/images/"
         :publishing-function org-publish-attachment)

        ("js"
         :base-directory "./js/"
         :base-extension "js"
         :publishing-directory "./public/js/"
         :publishing-function org-publish-attachment)

        ("css"
         :base-directory "./css/"
         :base-extension "css"
         :publishing-directory "./public/css/"
         :publishing-function org-publish-attachment)

        ("website" :components ("home" "notes" "images" "js" "css"))))

;; Generate the site output
(org-publish-all t)

(message "Build complete!")
