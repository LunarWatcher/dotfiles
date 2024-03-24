;; Init package manager {{{
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
;(package-refresh-contents)
;; }}}
;; Packages {{{
;; Make emacs usable (evil mode) {{{
(unless (package-installed-p 'evil)
  (package-install 'evil))

(require 'evil)
(evil-mode 1)
;; }}}
;; Orgmode {{{
; Annoys the shit out of me that they named the package just org
; Tbf, evil is consistent with this naming convention, but still.
(unless (package-installed-p 'org)
    (package-install 'org))

(require 'org)
;; }}}
;; File support {{{
(unless (package-installed-p 'markdown-mode)
    (package-install 'markdown-mode))
;; }}}
;; Theming. {{{
;; TODO: Shit theme, change when it isn't 2 in the morning
(unless (package-installed-p 'spacemacs-theme)
    (package-install 'spacemacs-theme))

(load-theme 'spacemacs-light t) 
;; TODO: make compatible with other NF naming conventions for other OSes
(set-frame-font "SauceCodePro Nerd Font 13" nil t)
;; }}}
;; }}}
;; Config {{{
(setq inhibit-startup-screen t)
(setq ring-bell-function 'ignore)
(global-display-line-numbers-mode)

(menu-bar-mode -1) 
(tool-bar-mode -1) ; Remove toolbar and GUI noise

; Syntax  stuff
(setq font-lock-maximum-decoration t)

; Yeet autosaves elsewhere

(unless (file-directory-p "~/.emacs.d/.autosaves")
    (make-directory "~/.emacs.d/.autosaves/"))

(setq auto-save-file-name-transforms
      `((".*" ,"~/.emacs.d/.autosaves/" t)))
; Disable file backups
; I really don't see the point in them. Autosaves, yes; they can avoid data loss if
; the editor suddenly dies. But file backups? Seems like it's just git but lazy
(setq make-backup-files nil)

; Spaces my beloved
; This is not enough to force 4 spaces and no  tabs in all files, because some major modes
; override it. Absolutely fucking moronic, but it's fine. I just need emacs to work for
; orgmode. Guess I won't bother configuring it generally in case I end up considering 
; switching to it for More Stuff:tm:
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; }}}
;; Don't touch; auto-generated shit {{{
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; }}}
