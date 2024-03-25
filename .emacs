;; Compat shit {{{
; Hack for ~ on Windows referring to %APPDATA% rather than home
; (and there not being an easy way to get the home directory reliably
; on windows, at least using environment variables or other syntax standards)
(if (eq system-type 'windows-nt)
    ; if
    (setq SPECIAL_HOME (substitute-env-vars "C:/Users/$USERNAME"))
    ; else
    (setq SPECIAL_HOME "~")
)

(setq ORG_HOME (format "%s/%s" SPECIAL_HOME "Documents/Syncthing/Orgzly/"))

;; }}}
;; Init package manager {{{
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/")
)
(package-initialize)
;(package-refresh-contents)
;; }}}
;; Packages {{{
;; Make emacs usable (evil mode + compat keybinds) {{{
(unless (package-installed-p 'evil)
    (package-install 'evil)
)

(require 'evil)
(evil-mode 1)

; Buffer navigation
(global-set-key (kbd "C-k") 'windmove-up)
(global-set-key (kbd "C-j") 'windmove-down)
(global-set-key (kbd "C-h") 'windmove-left)
(global-set-key (kbd "C-l") 'windmove-right)
;; }}}
;; Meta displays {{{
(unless (package-installed-p 'dashboard)
    (package-install 'dashboard)
)

(require 'dashboard)
(dashboard-setup-startup-hook)
;; }}}
;; Orgmode {{{
; Annoys the shit out of me that they named the package just org
; Tbf, evil is consistent with this naming convention, but still.
(unless (package-installed-p 'org)
    (package-install 'org)
)
(require 'org)
; Make tab do something rather than nothing (why the fuck is indentation so fucking shit?)
(setq org-adapt-indentation t)
(add-to-list 'org-agenda-files ORG_HOME)

(global-set-key "\C-ca" 'org-agenda)

;; }}}
;; File support {{{
(unless (package-installed-p 'markdown-mode)
    (package-install 'markdown-mode)
)
;; }}}
;; Nav {{{
(unless (package-installed-p 'dired-sidebar)
    (package-install 'dired-sidebar)
)
(require 'dired-sidebar)
(global-set-key (kbd "<f2>") 'dired-sidebar-toggle-sidebar)

;; }}}
;; Theming {{{
;; TODO: Shit theme, change when it isn't 2 in the morning
(unless (package-installed-p 'kaolin-themes)
    (package-install 'kaolin-themes)
)

(load-theme 'kaolin-light t) 
;; TODO: make compatible with other NF naming conventions for other OSes
(set-frame-font "SauceCodePro Nerd Font 13" nil t)
(set-cursor-color "#FF00EF")
;; }}}
;; }}}
;; Config {{{
(setq inhibit-startup-screen t) ; Get rid of the built-in start screen
(setq ring-bell-function 'ignore) ; Fuck bells
(global-display-line-numbers-mode) ; Line numbers

(setq default-directory ORG_HOME)

(menu-bar-mode -1) 
(tool-bar-mode -1) ; Remove toolbar and GUI noise

; Syntax  stuff
(setq font-lock-maximum-decoration t)

; Get rid of or move auto-generated files {{{
; Yeet autosaves elsewhere
; I'm not sure if make-directory is recursive, and I don't care enough to look it up
(unless (file-directory-p "~/.emacs.d")
    (make-directory "~/.emacs.d/")
)
(unless (file-directory-p "~/.emacs.d/.autosaves")
    (make-directory "~/.emacs.d/.autosaves/")
)

(setq auto-save-file-name-transforms
      `((".*" ,"~/.emacs.d/.autosaves/" t)))
; Kill lockfiles (.# files)
(setq create-lockfiles nil)
; Disable file backups
; I really don't see the point in them. Autosaves, yes; they can avoid data loss if
; the editor suddenly dies. But file backups? Seems like it's just git but lazy
(setq make-backup-files nil)
; }}}

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
 '(custom-safe-themes
   '("2ce76d65a813fae8cfee5c207f46f2a256bac69dacbb096051a7a8651aa252b0" "5a00018936fa1df1cd9d54bee02c8a64eafac941453ab48394e2ec2c498b834a" default))
 '(package-selected-packages '(evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; }}}
