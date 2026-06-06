(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)


(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))


(straight-use-package 'evil)
(straight-use-package 'evil-escape)
(straight-use-package 'general)

(evil-mode 1)
(evil-escape-mode 1)
(setq-default evil-escape-key-sequence "jk")

(straight-use-package 'doom-themes)

(load-theme 'doom-dark+ t)

;; window stuff start
(require 'general)
(general-create-definer leader 
  :states '(normal visual motion)
  :keymaps 'override
  :prefix "SPC")

(defun split-right-and-move ()
  (interactive)
  (let ((new-window (split-window-right)))
    (select-window new-window)))

(defun split-below-and-move ()
  (interactive)
  (let ((new-window (split-window-below)))
    (select-window new-window)))

(defvar previous-window-configuration nil)

(defun toggle-maximize-buffer ()
  (interactive)
  (if (one-window-p)
      (set-window-configuration previous-window-configuration)
      (setq previous-window-configuration (current-window-configuration))
  )
  (delete-other-window)
)

(leader
  "w v" #'split-right-and-move
  "w s" #'split-below-and-move
  "w d" #'delete-window
  "w o" #'delete-other-windows
  "w h" #'windmove-left
  "w j" #'windmove-down
  "w k" #'windmove-up
  "w l" #'windmove-right
  "w H" #'windmove-swap-states-left
  "w L" #'windmove-swap-states-right
  "w J" #'windmove-swap-states-down
  "w K" #'windmove-swap-states-up
  "w m" #'my/toggle-maximize-buffer
 )

;; window stuff end

;; file stuff start
(straight-use-package 'vertico)
(require 'vertico)
(vertico-mode 1)
(leader
 "f f" #'find-file
 "f s" #'save-buffer
)
;; file stuff end

;; buffer stuff start
(defun kill-other-buffers ()
  (interactive)
  (mapc (lambda (buf)
          (let ((name (buffer-name buf)))
            (unless (or (string= name (buffer-name))
                        (string-prefix-p " " name))
              (kill-buffer buf))))
        (buffer-list)))
(leader
  "b b" #'switch-to-buffer
  "b k" #'kill-current-buffer
  "b l" #'ibuffer
  "b n" #'next-buffer
  "b p" #'previous-buffer
  "b K" #'kill-other-buffers
)
;; buffer stuff end


;; project stuff start
(leader
  "p f" #'project-find-file
  "p p" #'project-switch-project
  "p s" #'project-find-regexp
  "p c" #'project-compile
  "p !" #'project-shell)
;; project stuff end


;; lsp stuff start 
(straight-use-package 'lsp-mode)
(setq lsp-headerline-breadcrumb-enable nil)
;; lsp stuff end

;; rust stuff start 
(straight-use-package 'rust-mode)
(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil) (lsp-deferred)))
;; rust stuff end

;; c/c++ stuff start
(add-hook 'c-mode-hook #'lsp-deferred)
(add-hook 'c++-mode-hook #'lsp-deferred)
;; c/c++ stuff end


;; generic start
(electric-pair-mode 1)
;; generic end


;; code stuff start
(leader
  "c d" #'lsp-find-definition
  "c s" #'lsp-find-references
  "c r" #'lsp-rename
  "c h" #'lsp-describe-thing-at-point
  "c C" #'compile
  "c c" #'recompile
  "c ;" #'comment-dwim
)
;; code stuff end


;; evaluate stuff start
(leader
  "e b" #'eval-buffer
 )
;; evaluate stuff end


;; zoom stuff start
(global-set-key (kbd "C-=") #'text-scale-increase)
(global-set-key (kbd "C--") #'text-scale-decrease)
(global-set-key (kbd "C-0") #'text-scale-set)
;; zoom stuff end


;; odin stuff start
(straight-use-package
 '(odin-mode :type git
             :host github
             :repo "mattt-b/odin-mode"))

(add-to-list 'auto-mode-alist '("\\.odin\\'" . odin-mode))

(add-hook 'odin-mode-hook #'lsp-deferred)

;; odin stuff end


;; python stuff start
(straight-use-package 'lsp-pyright)
(require 'lsp-pyright)
(add-hook 'python-mode-hook #'lsp-deferred) 

;; python stuff end

;; go stuff start
(defun my-go-style ()
  (setq tab-width 4)
  (setq indent-tabs-mode t)
  (setq lsp-go-use-gofumpt t)
)
(add-hook 'go-mode-hook (lambda ()
			  (lsp-deferred)
			  (my-go-style)
			  ))
(setq lsp-go-use-gofumpt t)
;; go stuff end


;; erlang stuff start
(straight-use-package 'erlang)
;; erlang stuff end


;; workspace stuff start
(tab-bar-mode 1)
(leader
  "<tab> N" #'tab-bar-new-tab
  "<tab> d" #'tab-bar-close-tab
  "<tab> n" #'tab-bar-switch-to-next-tab
  "<tab> p" #'tab-bar-switch-to-prev-tab
)
;; workspace stuff end


;; notes
;; - lsp errors myabe checked using flymake-...


