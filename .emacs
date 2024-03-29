;;; .emacs --- Emacs configuration file
;;; Commentary:
;;; Based on many different configs including that of Marc van der Sluys:
;;; AUTHOR: Jochem Stevense

;; Added by Package.el.  This must come before configurations of installed packages.  Don't delete this line.
;; If you don't want it, just comment it out by adding a semicolon to the start of the line.
;(package-initialize)

;;; CODE:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MELPA/ELPA ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/"))
(add-to-list 'load-path "~/.emacs.d/plugins/")
(package-initialize)

;; custom-set-variables was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(blink-cursor-mode nil)
 '(case-fold-search t)
 '(custom-safe-themes
   '("84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" default))
 '(package-selected-packages
   '(lsp-mode helm-gtags crux smartparens doom-themes cmake-mode company-c-headers astyle format-all clang-format+ clang-format blacken python-black auctex ## ac-c-headers auto-complete))
 '(show-paren-mode t))

;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; USE-PACKAGE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))
;; (eval-when-compile
;;   (require 'use-package))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MEMORY MANAGEMENT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ENCODING ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; KEYBOARD ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (eq system-type 'darwin)
  (setq mac-command-modifier       'alt
        mac-option-modifier        'alt
        mac-right-option-modifier  'meta
        mac-pass-control-to-system nil)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; VISUAL SETUP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)
(global-hl-line-mode +1)
(line-number-mode +1)
(global-display-line-numbers-mode 1)
(column-number-mode t)
(size-indication-mode t)
(setq inhibit-startup-screen t)

;; Set title to full path of file
(setq frame-title-format
      '((:eval (if (buffer-file-name)
           (abbreviate-file-name (buffer-file-name))
         "%b"))))

;; Preserve screen position when scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; Hack font: https://sourcefoundry.org/hack/ and unzip
;; and move .ttf files to /usr/share/fonts/truetype/Hack/
(set-frame-font "Hack 12" nil t)

;; Doom theme, smart mode line
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t)
  (doom-themes-visual-bell-config))
(use-package smart-mode-line-powerline-theme
  :ensure t)
(use-package smart-mode-line
  :ensure t
  :config
  (setq sml/theme 'powerline)
  (add-hook 'after-init-hook 'sml/setup))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GENERAL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set backup files location to temporary dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))
;; make "y" be sufficient instead of "yes"
(fset 'yes-or-no-p 'y-or-n-p)
;; Refresh files that were edited externally
(global-auto-revert-mode t)
;; Tabs are 4 spaces
(setq-default tab-width 4
              indent-tabs-mode nil)
;; Set key to kill buffer
(global-set-key (kbd "C-x k") 'kill-this-buffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ENABLE SOME PACKAGES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package diminish
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GENERAL DEV STUFF ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Whitespace
(use-package whitespace
  :ensure t
  :config
  (setq whitespace-style
        '(face tabs empty trailing lines-tail
               tab-mark space-before-tab
               indentation space-after-tab))

  (setq whitespace-line-column 100)
  ;; Clean accidental whitespaces
  (add-hook 'before-save-hook 'whitespace-cleanup)
  (global-whitespace-mode 1)
  )

(use-package yasnippet
  :ensure t
  :config
  (add-hook 'after-init-hook #'yas-global-mode))

(setq user-full-name "Your Name"
      user-mail-address "yourmail@example.com")

;; Insert/delete and highlight braces quotes and such in pairs
(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :config
  (progn
    (require 'smartparens-config)
    (smartparens-global-mode 1)
    (show-paren-mode t)))

;; Smarter region selection based on dwim syntax
(use-package expand-region
  :ensure t
  :bind ("M-m" . er/expand-region))

;; useful crux defaults
(use-package crux
  :ensure t
  :bind
  ("C-k" . crux-smart-kill-line)
  ("C-c n" . crux-cleanup-buffer-or-region)
  ("C-c f" . crux-recentf-find-file)
  ("C-a" . crux-move-beginning-of-line))

;; which-key enables a buffer to help find next keystroke
(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  (which-key-mode +1))

;; Jump around in current visual field
(use-package avy
  :ensure t
  :bind
  ("C-=" . avy-goto-char)
  :config
  (setq avy-background t))

(define-key global-map (kbd "C-c C-x C-c") 'uncomment-region)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; AUTOCOMPLETION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package company
  :ensure t
  :diminish company-mode
  :config
  (add-hook 'after-init-hook #'global-company-mode))

(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Remote editing ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package tramp
  :config
  (setq tramp-verbose 3)
  (setq tramp-default-method "sshx")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Git/project setup ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Trigger git status buffer
(use-package magit
  :bind (("C-M-g" . magit-status)))
;; Project manager to easily switch between files in a project
;; or between projects
(use-package projectile
  :ensure t
  :diminish projectile-mode
  :bind
  (("C-c p f" . helm-projectile-find-file)
   ("C-c p p" . helm-projectile-switch-project)
   ("C-c p s" . projectile-save-project-buffers))
  :config
  (projectile-mode +1)
)

;; Makes navigating emacs more comfortable
(use-package helm
  :ensure t
  :defer 2
  :bind
  ("M-x" . helm-M-x)
  ("C-x C-f" . helm-find-files)
  ("M-y" . helm-show-kill-ring)
  ("C-x b" . helm-mini)
  :config
  (helm-mode 1)
  (setq helm-split-window-inside-p t
    helm-move-to-line-cycle-in-source t)
  (setq helm-autoresize-max-height 0)
  (setq helm-autoresize-min-height 20)
  (helm-autoresize-mode 1)
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
  (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
  )

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on)
  (setq projectile-completion-system 'helm)
  (setq projectile-indexing-method 'alien)
  )

(setq helm-gtags-prefix-key "\C-c g") ; Must be set before loading helm-gtags
(use-package helm-gtags
  :ensure t
  :init
  (progn
    (setq helm-gtags-ignore-case t
          helm-gtags-auto-update t
          helm-gtags-use-input-at-cursor t
          helm-gtags-pulse-at-cursor t
          helm-gtags-suggested-key-mapping t))

  (add-hook 'dired-mode-hook 'helm-gtags-mode)
  (add-hook 'eshell-mode-hook 'helm-gtags-mode)
  (add-hook 'c-mode-hook 'helm-gtags-mode)
  (add-hook 'c++-mode-hook 'helm-gtags-mode)
  (add-hook 'asm-mode-hook 'helm-gtags-mode)

  ;; helm-gtags key bindings
  (with-eval-after-load 'helm-gtags
    (define-key helm-gtags-mode-map (kbd "C-c g a")
      'helm-gtags-tags-in-this-function)
    (define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
    (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
    (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
    (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
    (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history))
  )

(use-package server
  :preface
  (defun jsteven/ensure-server-running()
    "Ensure the emacs client server is running."
    (if (not (server-running-p))
        (server-start)))
  :config
  (jsteven/ensure-server-running))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C STUFF ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package which-func
  :ensure t
  :init
  (add-hook 'c-mode-hook 'which-function-mode)
  (add-hook 'c++-mode-hook 'which-function-mode)
  )

;; KERNEL C STUFF ;;
(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists by tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
         (column (c-langelem-2nd-pos c-syntactic-element))
         (offset (- (1+ column) anchor))
         (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

(dir-locals-set-class-variables
 'linux-kernel
 '((c-mode . (
        (c-basic-offset . 8)
        (c-label-minimum-indentation . 0)
        (c-offsets-alist . (
                (arglist-close         . c-lineup-arglist-tabs-only)
                (arglist-cont-nonempty .
                    (c-lineup-gcc-asm-reg c-lineup-arglist-tabs-only))
                (arglist-intro         . +)
                (brace-list-intro      . +)
                (c                     . c-lineup-C-comments)
                (case-label            . 0)
                (comment-intro         . c-lineup-comment)
                (cpp-define-intro      . +)
                (cpp-macro             . -1000)
                (cpp-macro-cont        . +)
                (defun-block-intro     . +)
                (else-clause           . 0)
                (func-decl-cont        . +)
                (inclass               . +)
                (inher-cont            . c-lineup-multi-inher)
                (knr-argdecl-intro     . 0)
                (label                 . -1000)
                (statement             . 0)
                (statement-block-intro . +)
                (statement-case-intro  . +)
                (statement-cont        . +)
                (substatement          . +)
                ))
        (indent-tabs-mode . t)
        (show-trailing-whitespace . t)
        ))))

(dir-locals-set-directory-class
 (expand-file-name "~/src/linux-trees")
 'linux-kernel)
;; END KERNEL C STUFF ;;

(use-package lsp-mode
  :hook ((c-mode          ; clangd
          c++-mode        ; clangd
          c-or-c++-mode   ; clangd
          java-mode       ; eclipse-jdtls
          js-mode         ; ts-ls (tsserver wrapper)
          js-jsx-mode     ; ts-ls (tsserver wrapper)
          typescript-mode ; ts-ls (tsserver wrapper)
          python-mode     ; pyright
          web-mode        ; ts-ls/HTML/CSS
          haskell-mode    ; haskell-language-server
          ) . lsp-deferred)
  :commands lsp
  :config
  (progn
    (setq lsp-auto-guess-root t
          lsp-log-io nil
          lsp-restart 'auto-restart
          lsp-enable-symbol-highlighting nil
          lsp-enable-on-type-formatting nil
          lsp-signature-auto-activate nil
          lsp-signature-render-documentation nil
          lsp-eldoc-hook nil
          lsp-modeline-code-actions-enable nil
          lsp-modeline-diagnostics-enable nil
          lsp-headerline-breadcrumb-enable nil
          lsp-semantic-tokens-enable nil
          lsp-enable-folding nil
          lsp-enable-imenu nil
          lsp-enable-snippet nil
          read-process-output-max (* 1024 1024) ;; 1MB
          lsp-idle-delay 0.5))

  ;; Ignore the build directory from cmake builds (not sure if a good idea yet)
  (add-to-list 'lsp-file-watch-ignored-directories
               "[/\\\\]build\\'")
  )

(use-package lsp-ui
  :commands
  lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable nil)
  (setq lsp-ui-doc-header t)
  (setq lsp-ui-doc-include-signature t)
  (setq lsp-ui-doc-border (face-foreground 'default))
  (setq lsp-ui-sideline-show-code-actions t)
  (setq lsp-ui-sideline-delay 0.05)
  )

;; Do auto formatting on save using clang-format
(use-package clang-format
  :preface
  ;; Auto format on save
  (defun clang-format-save-hook-for-this-buffer ()
    "Create a buffer local save hook."
    (add-hook 'before-save-hook
              (lambda ()
                (when (locate-dominating-file "." ".clang-format")
                  (clang-format-buffer))
                ;; Continue to save.
                nil)
              nil
              ;; Buffer local hook.
              t))
  :config
  (add-hook 'c-mode-hook (lambda () (clang-format-save-hook-for-this-buffer)))
  (add-hook 'c++-mode-hook (lambda () (clang-format-save-hook-for-this-buffer)))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MARKDOWN STUFF ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Markdown mode
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "/opt/MultiMarkdown/bin/MultiMarkdown.pl"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LATEX STUFF ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Enable LaTeX
(autoload 'latex-math-preview-expression "latex-math-preview" nil t)
(autoload 'latex-math-preview-insert-symbol "latex-math-preview" nil t)
(autoload 'latex-math-preview-save-image-file "latex-math-preview" nil t)
(autoload 'latex-math-preview-beamer-frame "latex-math-preview" nil t)
;; Set latex key binding
(global-set-key [(control ?x) (control ?p)] 'latex-math-preview-expression)

(add-hook 'yatex-mode-hook
         '(lambda ()
         (YaTeX-define-key "\M-p" 'latex-math-preview-expression)
         (YaTeX-define-key "\C-p" 'latex-math-preview-save-image-file)
         (YaTeX-define-key "j" 'latex-math-preview-insert-symbol)
         (YaTeX-define-key "\C-j" 'latex-math-preview-last-symbol-again)
         (YaTeX-define-key "\C-b" 'latex-math-preview-beamer-frame)))
(setq latex-math-preview-in-math-mode-p-func 'YaTeX-in-math-mode-p)

(defun xelatex ()
  "Compile latex with xelatex."
  (interactive)
  (message (buffer-file-name))
  (async-shell-command
   (format "/usr/bin/xelatex %s"
           (shell-quote-argument (buffer-file-name)
                                 ))))
(add-hook 'latex-mode-hook
          '(lambda ()
             (add-hook 'after-save-hook 'xelatex)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RUST STUFF ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package rustic
  :preface
  (defun rk/rustic-mode-hook ()
    ;; so that run C-c C-c C-r works without having to confirm, but don't try to
    ;; save rust buffers that are not file visiting. Once
    ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
    ;; no longer be necessary.
    (when buffer-file-name
      (setq-local buffer-save-without-query t)))
  :ensure
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  ;; uncomment for less flashiness
  ;; (setq lsp-eldoc-hook nil)
  ;; (setq lsp-enable-symbol-highlighting nil)
  ;; (setq lsp-signature-auto-activate nil)

  ;; comment to disable rustfmt on save
  (setq rustic-format-on-save t)
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PYTHON STUFF ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Set Python3.10 as default
(setq python-shell-interpreter "python3.10")

(add-hook 'python-mode-hook #'lsp)

(add-hook 'python-mode-hook 'elpy-enable)
(use-package elpy
    :demand t
    :bind (:map elpy-mode-map
          ("C-M-n" . elpy-nav-forward-block)
          ("C-M-p" . elpy-nav-backward-block))
    :hook ((elpy-mode . flycheck-mode)
           (elpy-mode . (lambda ()
                          (set (make-local-variable 'company-backends)
                               '((elpy-company-backend :with company-yasnippet))))))
    :init (elpy-enable)
    :config
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (setq elpy-shell-echo-output nil)
    (setq elpy-rpc-python-command "python3.10")
    (setq elpy-rpc-timeout 2)
    (add-hook 'elpy-mode-hook 'python-black-on-save-mode))

;; GO STUFF;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package go-complete)
(use-package go-autocomplete)
(use-package go-mode
  :config
  (add-hook 'go-mode-hook #'lsp)
  (add-hook 'go-mode-hook (lambda ()
              (setq tab-width 2 indent-tabs-mode 1)
              (add-hook 'before-save-hook 'gofmt-before-save))))

;; ORGMODE STUFF;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org
  :mode (("\\.org$" . org-mode))
  :init
  (setq org-support-shift-select t) ;; enable shift selection in org-mode
  (setq plantuml-default-exec-mode 'jar)
  (setq plantuml-jar-path "/usr/share/plantuml/plantuml.jar")
  (setq org-plantuml-jar-path (expand-file-name "/usr/share/plantuml/plantuml.jar"))
  (setq org-startup-with-inline-images t)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((plantuml . t)))

  (add-hook 'before-save-hook (lambda ()
                               (org-ctrl-c-ctrl-c)
                               (org-redisplay-inline-images)))
  )

;; PLANTUML STUFF;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package plantuml-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.puml\\'" . plantuml-mode))
  (setq plantuml-executable-path "/usr/bin/plantuml")
  (setq plantuml-default-exec-mode 'executable))

;; OTHER STUFF;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun command-line-diff (switch)
  "Perform diff on two files SWITCH."
  (let ((file1 (pop command-line-args-left))
        (file2 (pop command-line-args-left)))
    (ediff file1 file2)))
(add-to-list 'command-switch-alist '("diff" . command-line-diff))
;; Usage: emacs -diff file1 file2

; make ediff split horizontally
(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(use-package dockerfile-mode)
(use-package yaml-mode)
(use-package jupyter)

(put 'upcase-region 'disabled nil) ; Enable upcase-region

(provide '.emacs)
;;; .emacs ends here
