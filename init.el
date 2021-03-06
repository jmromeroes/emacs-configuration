
(require 'package)

;; you can run this file using M-x eval-buffer (M-x ev-b)
;; you can go to a variable/function definition through C-h (v for variables, f for functions)

;; required to add new repositories
;; after adding this you have to run M-x package-list-packages
;; then you have to run Shift+U x to update packages with new repository
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

;; on the very first load this is useful to pull packages archive if there are no archive contents in the computer
(unless package-archive-contents
  (package-refresh-contents))

;; install use-package if it's not already installed
;; functions that end with -p are normally predicates (return true/false)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; use-packages simplifies the settings for using and installing new packages
(require 'use-package)
;; when you wanna make sure that all packages you'll use are installed before they are run
(setq use-package-always-ensure t)

;; installing lsp-mode
(use-package lsp-mode
  :ensure t)

(use-package lsp-ivy)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  )

;; installing haskell mode
;; configuring hoogle and lsp-mode
(use-package haskell-mode
  :ensure t
  :defer t
  :init
   (use-package lsp-haskell
     :ensure t
     :after lsp
     :config (message "Loaded lsp-haskell"))

   (require 'lsp)
   (require 'lsp-haskell)
   (add-hook 'haskell-mode-hook #'lsp)
   (add-hook 'haskell-mode-hook #'haskell-decl-scan-mode)
   (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
  :bind (:map haskell-mode-map
   ("C-c h" . hoogle)
   ("C-c s" . haskell-mode-stylish-buffer))
  :config
     (message "Loaded haskell-mode"))

;; installing kotlin-mode
(use-package kotlin-mode)

;;added automatically
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes '(gruvbox-dark-medium))
 '(custom-safe-themes
   '("7661b762556018a44a29477b84757994d8386d6edee909409fabe0631952dad9" default))
 '(global-display-line-numbers-mode t)
 '(haskell-mode-hook
   '(flyspell-prog-mode haskell-indentation-mode highlight-uses-mode interactive-haskell-mode) t)
 '(ispell-dictionary nil)
 '(package-selected-packages
   '(dhall-mode yaml-mode company-mode lsp-ivy lsp-haskell crux sunrise sunrise-commander bm helm-swoop minimap lsp-mode haskell-mode js2-mode flycheck multiple-cursors magit counsel-projectile projectile all-the-icons javascript-mode flymake-haskell-multi neotree company markdown-mode auto-org-md drag-stuff scss-mode org-bullets evil general helpful ivy-rich which-key rainbow-delimiters tide typescript-mode rjsx-mode web-mode anaconda-mode doom-modeline counsel ivy use-package gruvbox-theme))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Fira Mono" :foundry "CTDB" :slant normal :weight normal :height 113 :width normal)))))

;; load-theme requires you to install the theme package
;; this one was installed through melpa
(load-theme 'gruvbox-dark-medium)

;; this sets the key <escape> to quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; :diminish is used so emacs does not show the ivy package as a minor mode in the lower bar
;; :bind works to set the swiper instead of isearch, also sets the key map bindings,
;; in this case it's very similar to vim such that you don't have to move your hand too much
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; I also installed counsel through package-install
(use-package counsel)

;; for showing the icons in different packages like doom-modeline or neotree
(use-package all-the-icons)
;; after this it's necessary to run M-x all-the-icons-install-fonts


;; add doom-modeline to improve a little the ui in the lower bar
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; show line numbers
(global-display-line-numbers-mode)

;; this is the package to use for python
(use-package anaconda-mode)

;; to activate anaconda-mode whenever a python file is used
(add-hook 'python-mode-hook 'anaconda-mode)

;; this shows the parameters received by a function when pointer is between function call parentheses
(add-hook 'python-mode-hook 'anaconda-eldoc-mode)

;; this makes the parentheses scopes clear by coloring them with specific colors both the opening and the closing ones
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; which-key shows possible key-bindings for the incomplete command that you have entered,
;; so it makes it easy to remember all the bindings
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;; more friendly descriptions and information in general for ivy and counsel
(use-package ivy-rich
  :init (ivy-rich-mode 1))

;; although counsel is imported by ivy, here we configure some usual key bindings such that they match the default emacs features with similar functionality
(use-package counsel
  :bind (("M-x". counsel-M-x)
         ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil))

;; this binds some functions that are already provided by counsel to descibe functions, keys and variables to helpful descriptions that have more information and functionalities, which makes it better for you to understand the functionalities of your configuration
(use-package helpful
  :custom
  (counsel-describe-function-function #'helful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; easily setting bindings for changing buffer fast
(use-package general)
(general-define-key
   "C-M-j" 'counsel-switch-buffer)


;; projectile works for interaction of projects, isolating projects without external dependencies. Used for project navigation and management.
;; this considers projects folders that are git, mercurial, bazaar or darcs. Also lein, maven, sbt, scons, rebar3 and bundler.
;; also you can create an empty .projectile file inside a folder to consider it a project
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom (projectile-completion-system 'ivy)
  :init
  (when (file-directory-p "~/Documents/")
    (setq projectile-project-search-path '("~/Documents/")))
  (setq projectile-switch-project-action #'projectile-dired))
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; some more integration between ivy counsel and projectile for navigating easily in projects
(use-package counsel-projectile
 :config (counsel-projectile-mode))

;; easy git management for projects
(use-package magit)

;; for manipulating multiple lines at the same time
(use-package multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)


;; key bindings for increasing and decreasing text scalej
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)


;; orgmode for organizing life
;; Changed default ellipsis "..." with "???"
(use-package org
  :config
  (setq org-ellipsis " ???"))

;; Replacing * with fun shapes in different org mode indentation levels
(use-package org-bullets
 :ensure t 
 :init (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; was going to add shift support but I think I prefer the C+SPACE way

;; for easily moving lines and regions using M-up M-down
(use-package drag-stuff
  :ensure t
  :config
  (drag-stuff-global-mode 1)
  (drag-stuff-define-keys))


;; mark down mode
;; I installed pandoc and the binary is located at usr/bin/pandoc
;; so I use it as the main markdown-command
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "/usr/bin/pandoc"))

;; library for buffer oriented auto completion
(use-package company
  :ensure t
  :config
  (setq company-show-numbers t)
  (setq company-tooltip-align-annotations t)

  (setq company-tooltip-flip-when-above t)
  (global-company-mode))

;; avoiding problems with lock files that emacs creates automatically
;; e.g it was having problems while working with React
(setq create-lockfiles nil)

;; syntax checking
(use-package flycheck
  :config
  (global-flycheck-mode))


;; neotree for watching tree files easily
(use-package neotree
  :config
  (global-set-key [f8] 'neotree-toggle))

;; React + TypeScript settings

;; Following tide default settings
(defun setup-tide-mode ()
  (interactive) ;; Making the function callable by M-x for example
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)

  (company-mode +1))

;; HTML rendering
(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
	 ("\\.tsx\\'" . web-mode)
	 ("\\.jsx\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2
	web-mode-css-indent-offset 2
	web-mode-code-indent-offset 2
	web-mode-block-padding 2
	web-mode-comment-style 2

	web-mode-enable-css-colorization t
	web-mode-enable-auto-pairing t
	web-mode-enable-comment-keywords t
	web-mode-enable-current-element-highlight t
	)
  (add-hook 'web-mode-hook
	    (lambda ()
	      (when (string-equal "tsx" (file-name-extension buffer-file-name))
		(setup-tide-mode))))
  ;; enable typescript-tslint checker
  (flycheck-add-mode 'typescript-tslint 'web-mode))

;; this is for creating the configuration for formatting of TypeScript files
(use-package typescript-mode
  :ensure t
  :config
  (setq typescript-indent-level 2)
  (add-hook 'typescript-mode #'subword-mode))

;; this is for creating the configuration for formatting of JavaScript files
(use-package js2-mode
  :ensure t
  :config
  (setq js-indent-level 2))

;; this is for creating the configuration for formatting of JSON files
(add-hook 'json-mode-hook
  (lambda ()
    (make-local-variable 'js-indent-level)
    (setq js-indent-level 2)))

;; this helps creating a dynamic environment for working in TypeScript with advanced features like type checking, inspection and showing errors
(use-package tide
  :init
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
	 (typescript-mode . tide-hl-identifier-mode)
	 (before-save . tide-format-before-save)))

;; prevent backup files from being created
(setq make-backup-files nil)

;; Wrap words according to size of emacs buffer
(visual-line-mode t)

;; setting transparency to emacs window
(set-frame-parameter (selected-frame) 'alpha '(97 97))
(add-to-list 'default-frame-alist '(alpha 97 97))

;; adding minimap to have better scope of clode globally
(use-package minimap)

;; add bookmarks management system to emacs 
(use-package bm)

;; CRUX: A Collection of Ridiculously Useful eXtensions for Emacs
(use-package crux)


(provide 'init)
;;; init ends here

