;; visual tweaks
(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)

;; edit default ring bell to blink mode line instead
(setq visible-bell nil)
(setq ring-bell-function (lambda ()
(invert-face 'mode-line)
(run-with-timer 0.1 nil 'invert-face 'mode-line)))

;; font
(set-face-attribute 'default nil :font "Iosevka" :height 150)

;; i use straight now 
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;init use-package
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)
(setq use-package-always-ensure t)

;; vim keybindings
(use-package evil
  :config
  (evil-mode 1))

;; command-logs nothing much
(use-package command-log-mode)

;; completion for life
(use-package ivy
  :diminish (ivy-mode . "")
  :init (ivy-mode 1) ; globally at startup
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-height 10)
  (setq ivy-count-format "%d/%d "))

;; reject tradition embrace modernivy
(use-package counsel
  :bind* ; load when pressed
  (("M-x"     . counsel-M-x)
   ("C-x C-r" . counsel-recentf)  ; search for recently edited
   ("C-s"     . swiper)
   ("s-f"     . swiper)
   ("C-x C-f" . counsel-find-file)
   ("C-c g"   . counsel-git)      ; search for files in git repo
   ("C-c j"   . counsel-git-grep) ; search for regexp in git repo
   ("C-x b"   . counsel-switch-buffer)
   ("C-x C-b"   . counsel-switch-buffer) ; if i accidently type
   ("C-c /"   . counsel-ag)       ; Use ag for regexp
   ("C-x l"   . counsel-locate)
   ("<f1> f"  . counsel-describe-function)
   ("<f1> v"  . counsel-describe-variable)
   ("<f1> l"  . counsel-find-library)
   ("<f2> i"  . counsel-info-lookup-symbol)
   ("C-c C-r" . ivy-resume)))

;; smartparens
(use-package smartparens
  :config
  (require 'smartparens-config)
  (add-hook 'lisp-mode-hook #'smartparens-strict-mode))


;; sorting and filtering (magical)
(use-package ivy-prescient
  :after counsel
  :config
  (prescient-persist-mode 1)
  (ivy-prescient-mode 1))

;; use shift + arrows to move around buffers (very convenient)
(windmove-default-keybindings)

;; theme
(use-package nord-theme
  :load-path "~/.emacs.d.vanilla/themes/"
  :config
  (load-theme 'nord t))

;; auto completion
(use-package company
  :init
  (add-hook 'after-init-hook 'global-company-mode))


(use-package company-quickhelp
  :after company
  :config
  (company-quickhelp-mode))

;; eldoc
(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'eldoc-mode)
(add-hook 'ielm-mode-hook 'eldoc-mode)

;; flycheck
(use-package flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)


;; smooth scroll
(use-package smooth-scrolling
  :init 
  (smooth-scrolling-mode 1))

;; which-key
(use-package which-key)
(which-key-mode)

;; make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; magit
(use-package magit)

;; neotree
(use-package neotree
  :config
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (setq neo-smart-open t)
)


(use-package all-the-icons)

;; projectile
(use-package projectile
  :config
  :bind (("s-p" . projectile-command-map)
	 ("C-c f" . projectile-find-file-hook))
  )

;; colored parens
(use-package rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(projectile-mode 1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)


;; =========================================
;; ========= Dev Environment setup =========
;; =========================================

;; eglot
(use-package eglot)
(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd-11"))
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c-mode-hook 'eglot-ensure)




;; python
(use-package elpy)
(elpy-enable)
(when (load "flycheck" t t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(add-hook 'elpy-mode-hook (lambda ()
                            (add-hook 'before-save-hook
                                      'elpy-format-code nil t)))


