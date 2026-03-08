;; Custom shit (whatever that is) {{{
;; This needs to be first, or the load-theme command won't shut up
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :foreground "deep pink" :height 2.0))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :foreground "medium purple" :height 1.7))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :foreground "dark orange" :height 1.5))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :foreground "dark cyan" :height 1.3)))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("5c8a1b64431e03387348270f50470f64e28dfae0084d33108c33a81c1e126ad6" default))
 '(package-selected-packages '(doom-modeline goto-chg evil doom-themes)))
;; }}}
;; Initialise packages {{{
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; }}}
;; Install packages {{{
(use-package goto-chg
  :ensure t)

(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode)
)
(use-package evil-nerd-commenter
  :ensure t
)
(use-package evil-collection
  :ensure t
)
(use-package evil-commentary
  :ensure t
  :config
  (evil-commentary-mode)
)
(use-package evil-numbers
  :ensure t
  :config
  (global-set-key (kbd "C-a") 'evil-numbers/inc-at-pt)
  (global-set-key (kbd "C-x") 'evil-numbers/dec-at-pt)
)

(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides
   '((file (styles partial-completion)))))

(use-package consult
  :ensure t
  :config
  (setq consult-fd-args '("fdfind" "--hidden"))
  (setq consult-ripgrep-args '("rg --null --line-buffered --color=never --max-columns=1000 --smart-case --no-heading --with-filename --line-number --hidden"))

  (evil-define-key 'normal 'global (kbd "\\ z x") #'consult-fd)
  (evil-define-key 'normal 'global (kbd "\\ z c") #'consult-ripgrep)

)

(use-package savehist
  :ensure t
  :init
  (savehist-mode))

(use-package breadcrumb
  :ensure t
  :config
  (breadcrumb-mode)
)

(use-package cmake-mode
  :ensure t)
(use-package typescript-mode
  :ensure t)
(use-package lua-mode
  :ensure t)

; TODO: do I need this? Looks like eglot is built-in as of emacs 29, but not
; sure if this is the right way to load it
(use-package eglot
  :ensure t
  :config
  (add-hook 'c++-mode-hook 'eglot-ensure)
  (add-hook 'c-mode-hook 'eglot-ensure)
  (add-hook 'lua-mode-hook 'eglot-ensure)
  (add-hook 'javascript-mode-hook 'eglot-ensure)
  (add-hook 'typescript-mode-hook 'eglot-ensure)
  (add-hook 'python-mode-hook 'eglot-ensure)

  ;; TODO: how do I make this a popup isntead of minibuffer shit?
  (evil-define-key 'normal 'global (kbd "M-q") #'eglot-code-actions)
)
(use-package treesit-auto
  :ensure t
  :config
  (global-treesit-auto-mode)
)
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  :config
  (global-corfu-mode)
  (corfu-popupinfo-mode)

)
(use-package eldoc-box
  :ensure t
  :hook (eldoc-mode . eldoc-box-hover-at-point-mode))

(use-package nerd-icons
  :ensure t
)
(use-package projectile
  :ensure t
  :config
)
(use-package neotree
  :ensure t
  :config
  (setq neo-theme (if (display-graphic-p) 'nerd-icons 'arrow))
  (setq neo-show-hidden-files t)
  (setq neo-autorefresh t)

  (global-set-key [f2] 'neotree-toggle)
  (define-key neotree-mode-map (kbd "<return>") #'neotree-enter)
)

(use-package doom-themes
  :ensure t
)
(load-theme 'doom-tomorrow-day)
(use-package doom-modeline
  :ensure t
  :config
  (doom-modeline-mode 1)
  ;; Not sure what half of this does; pretty sure it's all the defaults.
  (setq doom-modeline-icon t)
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-major-mode-color-icon t)
  (setq doom-modeline-buffer-state-icon t)
  (setq doom-modeline-buffer-modification-icon t)
  (setq doom-modeline-buffer-name t)
  (setq doom-modeline-lsp-icon t)
  (setq doom-modeline-percent-position '(-3 "%p"))
  (setq doom-modeline-position-column-format '("C%c"))
  (setq doom-modeline-modal-icon t)
)
;; }}}
;; Load builtins {{{
(require 'treesit)
(require 'tempo)
;; }}}
;; Configure shit {{{
;; Tempo {{{
(setq tempo-interactive t)

(defvar c-tempo-tags nil
  "Tempo tags for C mode")

(defvar c++-tempo-tags nil
  "Tempo tags for C++ mode")

(tempo-define-template "c-ifwin"
                        '("#if defined(WIN32) || defined(_WIN32) || defined(__WIN32__) || defined(__NT__)" n>
                        p n>
                        "#endif" n>)
                        "ifwin"
                        "Insert a Windows macro check"
                        'c-tempo-tags
)

;; }}}
;; Evil mode et. al {{{
(evil-mode 1)
(evil-collection-init)
(evil-set-undo-system 'undo-redo)
;; }}}
;; Autocomplete {{{
(flymake-mode t)

(define-key corfu-map (kbd "C-y") #'corfu-insert)
(global-set-key (kbd "C-SPC") #'completion-at-point)
;; }}}
;; }}}
;; Configure emacs standards {{{
(setq warning-minimum-level :error) ;; prevent emacs from whining about evil
(set-frame-font "SauceCodePro Nerd Font 12" nil t)

(global-display-line-numbers-mode 1) ;; set number
(global-hl-line-mode 1) ;; set cursorline

(electric-pair-mode) ;; enable electric-pair by default

;; Hide startup shit
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(setq initial-buffer-choice t)

(setq-default indent-tabs-mode nil)
(setq-default tab-always-indent nil)
(setq-default tab-width 4)
(setq-default tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
(setq-default indent-line-function 'insert-tab)

(setq-default whitespace-style '(face tabs spaces space-mark tab-mark newline-mark trailing))
(setq-default whitespace-display-mappings
      '(
        ;; carriage return (Windows) -> ¶ else #
        (newline-mark ?\r [182] [35])
        ;; tabs -> » else >
        (tab-mark ?\t [187 ?\t] [62 ?\t])))
(global-whitespace-mode 1)
;; }}}
;; Disable built-in toolbar
(tool-bar-mode -1)

;; Tab bar
(tab-bar-mode) ; Proper tabs
(global-tab-line-mode) ; Buffer tabs

;; C mode {{{
(defun my-c-mode-common-hook ()
  ;; https://www.gnu.org/software/emacs//manual/html_node/efaq/Customizing-C-and-C_002b_002b-indentation.html
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'innamespace 0)
  (setq c++-tab-always-indent 'complete)
  (setq c-basic-offset 4)
  (setq c-indent-level 4)

  (set-tempo)
  (tempo-use-tag-list 'c-tempo-tags)
  (tempo-use-tag-list 'c++-tempo-tags))))
)

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
;; }}}

;; disable soft wrap
(add-hook 'prog-mode-hook (lambda ()
                            (visual-line-mode -1)
                            (toggle-truncate-lines 1)))

;; disable scroll acceleration
(setq mouse-wheel-scroll-amount '(0.07))
(setq mouse-wheel-progressive-speed nil)

;; no jumping on scroll
(setq scroll-step 1)
;; scrolloff
(setq scroll-margin 5)
