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
 '(catppuccin-dark-line-numbers-background t)
 '(catppuccin-flavor 'latte)
 '(custom-safe-themes
   '("5c7720c63b729140ed88cf35413f36c728ab7c70f8cd8422d9ee1cedeb618de5" "b99ff6bfa13f0273ff8d0d0fd17cc44fab71dfdc293c7a8528280e690f084ef0" "5c8a1b64431e03387348270f50470f64e28dfae0084d33108c33a81c1e126ad6" default))
 '(helm-minibuffer-history-key "M-p")
 '(package-selected-packages
   '(catppuccin-theme git-modes git-gutter magit doom-modeline goto-chg evil)))
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
(use-package emacs
  :custom
  (require-final-newline t)
)

(use-package goto-chg
  :ensure t)

(use-package evil
  :ensure t
  :hook
  ('prog-mode . #'hs-minor-mode)
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-integration t)
  ;; Not sure why this needs to be run before evil mode is started, but whatever
  (setq select-enable-clipboard nil)
  (setq kill-whole-line 1)
  :config
  (evil-mode)
  (evil-set-undo-system 'undo-redo)
  (setq evil-respect-visual-line-mode 1)

  ;; Emacs maps S-ins and C-ins by default, but these maps use the kill ring, which no longer is linked to the
  ;; system clipboard (select-enable-clipboard), so they need to be overridden to use the system clipboard
  (evil-define-key 'normal 'global (kbd "S-<insert>") (lambda() (interactive) (evil-paste-from-register ?+)))
  ;; this is so stupid, but looks forced. evil-copy-from-register is
  ;; simply not a thing
  (evil-define-key 'visual 'evil-visual-state-map (kbd "C-<insert>")
    (lambda()
      (interactive)
      (let ((beg (region-beginning))
            (end (region-end))
            (type (evil-visual-type)))
        (if (eq type 'block)
            (evil-yank-rectangle beg end ?+)
          (if (eq type 'line)
            (evil-yank-lines beg end ?+)
            (evil-yank beg end type ?+)
          )
        )
      )
    )
  )
)
(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode)
)
(use-package evil-collection
  :ensure t
  :init
  (setq evil-collection-key-blacklist '("C-y" "C-m"))
  :config
  (evil-collection-init)
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
  (orderless-matching-styles '(orderless-literal orderless-flex orderless-regexp))
  (completion-category-overrides
   '((file (styles partial-completion)))))

(use-package consult
  :ensure t
)

;; Note to self: do not install helm. It's fast, but it hijacks everything and works awfully with evil mode
(use-package affe
  :ensure t
  :config
  (defun livi-grep()
    "affe-grep with hidden files excluded"
    (interactive)
    (let (
      (affe-grep-command "rg --glob \"!.git\" --hidden --null --color=never --max-columns=1000 --no-heading --line-number -v ^$")
    )
      (affe-grep)
    )
  )
  (defun livi-grep-nogitignore()
    "affe-grep with hidden files excluded"
    (interactive)
    (let (
      (affe-grep-command "rg --glob \"!.git\" --hidden --null --color=never --max-columns=1000 --no-heading --line-number --no-ignore-vcs -v ^$")
    )
      (affe-grep)
    )
  )

  (defun livi-find()
    "affe-find with hidden files excluded"
    (interactive)
    (let (
      (affe-find-command "rg --glob \"!.git\" --hidden --color=never --files")
    )
      (affe-find)
    )
  )
  (defun livi-find-nogitignore()
    "affe-find with hidden files excluded"
    (interactive)
    (let (
      (affe-find-command "rg --glob \"!.git\" --hidden --color=never --files --no-ignore-vcs")
    )
      (affe-find)
    )
  )

  (setq affe-find-command "rg --glob \"!.git\" --hidden --color=never --files")
  (setq affe-grep-command "rg --glob \"!.git\" --hidden --null --color=never --max-columns=1000 --no-heading --line-number -v ^$")
  (setq affe-count 1000)

  ;; Not a huge fan of how most emacs fuzzy finders use spaces to separate tokens, but affe at least uses spaces and not #, which is
  ;; marginally better. I think this is as close to fzf as I get
  (evil-define-key 'normal 'global (kbd "\\ z x") #'livi-find)
  (evil-define-key 'normal 'global (kbd "\\ z X") #'livi-find-nogitignore)

  (evil-define-key 'normal 'global (kbd "\\ z c") #'livi-grep)
  (evil-define-key 'normal 'global (kbd "\\ z C") #'livi-grep-nogitignore)

  ;; No, actually applying orderless here changes the previous comment. It now searches much more like fzf.
  ;; Not sure if it's worth trying to add it to consult as well, largely because consult is still really sluggish, whereas this has the fzf-tiers
  ;; of responsiveness I'd want. (shame fzf also uses AI slop, but it's whatever at this point)
  ;; Need to fuck around with the orderless-matching-styles. struggling to get it to work the way I want
  ;; That said, the style dispatchers might make up for this. `=dotfiles .zsh' more closely enforces what to match.
  ;; The default dotfiles/.zsh works fine when the dotfiles repo is the cwd, but partially matches paths in `Documents/` for some fucking reason
  ;; TODO: does orderless have a way to order things, such that consecutive chars outweigh non-consecutive chars? Pretty sure that would be the
  ;; last bit required for as close to fzf-like completions as possible
  ;;
  ;; Also, the preview feature in affe-grep is such a nice feature. Seeing the entire context is really practical
  (defun affe-orderless-regexp-compiler (input _type _ignorecase)
    (setq input (cdr (orderless-compile input)))
    (cons input (apply-partially #'orderless--highlight input t)))
  (setq affe-regexp-compiler #'affe-orderless-regexp-compiler)
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

;; TODO: this is getting ridiculous
(use-package cmake-mode
  :ensure t)
(use-package typescript-mode
  :ensure t)
(use-package lua-mode
  :ensure t)
(use-package yaml-mode
  :ensure t)
(use-package json-mode
  :ensure t)
(use-package kotlin-mode
  :ensure t)
(use-package rust-mode
  :ensure t)
(use-package markdown-mode
  :ensure t)

(use-package project
  :ensure t
  :config
)

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

  (defun livi-find-lsp(lsp-name)
    "Returns the path to an LSP. Returns lspinstaller location if
installed, then defaulting to the name of the LSP for a fallback"
    (let
        ((path (shell-command-to-string (concat "lspinstaller find " lsp-name))))
      (if (string-equal path "")
          lsp-name
        (substring path 0 -1)
        )
      )
  )

  (add-to-list
   'eglot-server-programs
   `(python-mode ,(livi-find-lsp "ty") "server")
   )

  (setq project-vc-extra-root-markers
        '(
          ".venv/"
          "pyproject.toml"
          "requirements.txt"
          "CMakeLists.txt"
          "settings.gradle.kts"
          ))

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
  ;; I don't entirely understand what this does, but this half seems to be required to be able to select the first entry?
  ;; I still now need ctrl-n ctrl-y to select the first result. I can probably just add a key that does c-n c-y
  (corfu-preselect 'prompt)
  :config
  (global-corfu-mode)
  (corfu-popupinfo-mode)

  (define-key corfu-map (kbd "RET") nil)
  ;; I cannot for the life of me map ctrl-y
  ;; It's taken by an evil mode motion keybind that results in characters being added
  ;; Alt-y is also mapped, but it is respected for some reason?
  ;; Evil mode is fucking weird
  (define-key corfu-map (kbd "M-y") #'corfu-insert)
  (global-set-key (kbd "C-SPC") #'completion-at-point)
)
(use-package cape
  :ensure t
  ;; TODO: it's supposed to be possible to get this into the standard completion at point function, but can't figure out how.
  ;; It's really unclear what does and doesn't work. Some leads for later:
  ;; * https://github.com/minad/cape/discussions/160
  ;; * https://github.com/minad/cape/discussions/154 (implies the corfu wiki is wrong about stuff)
  ;; Once I do figure it out though, it should be really nice
  :bind (("C-c f" . cape-file))
)

(use-package eldoc-box
  :ensure t
  :hook (eldoc-mode . eldoc-box-hover-at-point-mode))

(use-package nerd-icons
  :ensure t
)
(use-package neotree
  :ensure t
  :config
  (setq neo-theme (if (display-graphic-p) 'nerd-icons 'arrow))
  (setq neo-show-hidden-files t)

  (global-set-key [f2] 'neotree-toggle)
  (define-key neotree-mode-map (kbd "<return>") #'neotree-enter)
)

(use-package catppuccin-theme
  :ensure t
  :config
  (load-theme 'catppuccin :no-confirm)
)


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
  (setq doom-modeline-enable-buffer-position t)

  (setq doom-modeline-total-line-number t)

  (setq doom-modeline-modal-icon t)
  (setq doom-modeline-enable-word-count t)
  (setq doom-modeline-continuous-word-count-modes '(markdown-mode text-mode))
)

(use-package magit
  :ensure t
)
(use-package git-modes
  :ensure t)
(use-package git-gutter
  :ensure t
  :config
  (global-git-gutter-mode)
)

(use-package highlight-indent-guides
  :ensure t
  :config
  (setq highlight-indent-guides-method 'character)
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

(evil-define-key 'insert 'global (kbd "C-t") #'tempo-complete-tag)
;; }}}
;; Diagnostics {{{
(flymake-mode t)
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

(setq-default indent-tabs-mode nil) ; use tabs instead of spaces
(setq-default tab-always-indent nil)
(setq-default tab-width 4)
(setq-default indent-line-function 'insert-tab)
;; I am no longer fucking asking
(global-set-key (kbd "TAB") 'tab-to-tab-stop)

(setq-default whitespace-style '(face tab-mark newline-mark trailing))
(setq-default whitespace-display-mappings
      '(
        ;; carriage return (Windows) -> ¶ else #
        (newline-mark ?\r [182] [35])
        ;; tabs -> » else >
        (tab-mark ?\t [187 ?\t] [62 ?\t])
        )
      )
(global-whitespace-mode 1)
;; }}}
;; Disable built-in toolbar
(tool-bar-mode -1)

;; Tab bar
(tab-bar-mode) ; Proper tabs
(global-tab-line-mode) ; Buffer tabs

;; C mode {{{
(defun livi-c-mode-hook()
  ;; https://www.gnu.org/software/emacs//manual/html_node/efaq/Customizing-C-and-C_002b_002b-indentation.html
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'innamespace 0)
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'arglist-close 0)
  (c-set-offset 'arglist-cont-nonempty '+)

  ;; Fucking why
  ;; https://emacs.stackexchange.com/a/19316
  (setq c-ignore-auto-fill '(string))

  (add-to-list 'c-offsets-alist '(arglist-close . c-lineup-close-paren))
  (setq c-tab-always-indent nil)
  (setq c-basic-offset 4)
  (setq c-indent-level 4)

  (tempo-use-tag-list 'c-tempo-tags)
  ;; TODO: move to a separate C++ hook
  (tempo-use-tag-list 'c++-tempo-tags)

  (local-set-key (kbd "TAB") 'tab-to-tab-stop)
)

(add-hook 'c-mode-common-hook 'livi-c-mode-hook)
;; }}}
;; YAML mode {{{
(defun livi-yaml-mode-hook()
  (setq-local tab-width 2)
  ;; Yaml counts as text, which disables all the nice features
  (livi-code-mode)
)
(add-hook 'yaml-mode-hook 'livi-yaml-mode-hook)
;; }}}
;; Python mode
(add-hook
 'python-mode-hook
 (lambda()
   (setq fill-column 79) ; per pep-whatever
 )
)

(setq-default fill-column 120)
;; Required to display fill-column
(global-display-fill-column-indicator-mode)

(defun livi-code-mode()
  "Pseudo-mode used for things used in code, to allow for use in filetypes that don't count as code."
  (visual-line-mode -1)
  (auto-fill-mode 1)
  (toggle-truncate-lines 1)
  (electric-indent-mode 1)
  (setq evil-auto-indent 1)
  (highlight-indent-guides-mode 1)
)
;; disable soft wrap in code
(add-hook 'prog-mode-hook 'livi-code-mode)
;; enable word wrap in text files
(add-hook 'text-mode-hook (lambda ()
  (visual-line-mode 1)
  (auto-fill-mode -1)
  (setq fill-column 999999999)
  (display-fill-column-indicator-mode -1)

  ;; required to get indents to fuck off
  (electric-indent-mode -1)
  (setq evil-auto-indent nil)
))

(add-hook
  'git-commit-mode-hook
  (lambda()
    (visual-line-mode -1)
    (auto-fill-mode 1)
    ;; the first line is at 50, but can't have two wrap points
    (setq fill-column 72)

    (display-fill-column-indicator-mode 1)
  )
)

;; Dump autofiles elsewhere
(setf make-backup-files nil)
(setq auto-save-file-name-transforms
  `((".*" "~/.emacs-saves/" t)))
(setq lock-file-name-transforms
   '(("\\`/.*/\\([^/]+\\)\\'" "/tmp/\\1" t)))

;; disable scroll acceleration
(setq-default mouse-wheel-scroll-amount '(0.07))
(setq-default mouse-wheel-progressive-speed nil)

;; no jumping on scroll
(setq scroll-step 1)
;; scrolloff
(setq scroll-margin 5)

;; Misc. minor modes
(column-number-mode)

(setq find-program "fdfind")
