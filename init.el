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
  (if (and (one-window-p)
           previous-window-configuration)
      (set-window-configuration previous-window-configuration)
    (setq previous-window-configuration
          (current-window-configuration))
    (delete-other-windows)))

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
  "w m" #'toggle-maximize-buffer
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

;; searcing stuff start
(straight-use-package 'rg)
;; searcing stuff end

;; project stuff start
(leader
  "p f" #'project-find-file
  "p p" #'project-switch-project
  "p s" #'rg-project
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

(defun run-rad-debugger () ;;@WINDOWS-ONLY ;;@OS-SPECIFIC
  (interactive)
  (let*
      ;; variables
      (
       (root (project-root (project-current t)))
       (default-directory root)
       (dbg (expand-file-name "dbg.bat" root))
      )
    (if (file-exists-p dbg)
       (shell-command dbg)
       (message "no dbg.bat found in %s" root)
    )
  )
)

(add-hook 'c-mode-hook (lambda () (lsp-deferred)))
(add-hook 'c++-mode-hook #'lsp-deferred)
;; c/c++ stuff end


;; generic start
(toggle-debug-on-error)
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
  "c D" #'run-rad-debugger ;;@WINDOWS-ONLY ;;@OS-SPECIFIC
  "c f r" #'lsp-find-references
)
;; Code stuff end


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
(straight-use-package 'go-mode)
(add-hook 'go-mode-hook (lambda ()
			  (lsp-deferred)
			  (my-go-style)
			  ))
(setq lsp-go-use-gofumpt t)
;; go stuff end


;; erlang stuff start
(straight-use-package 'erlang)
(add-hook 'erlang-mode-hook (lambda () (setq indent-tabs-mode nil) (lsp-deferred)))
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


;; verilog stuff start
(straight-use-package 'verilog-mode)
(add-hook 'verilog-mode-hook (lambda () (message "verilog start") (lsp-deferred)))
;; verilog stuff end


;; ternimal stuff start
(straight-use-package 'vterm)

(defun vterm-send-region (start end)
  "Send selected region to vterm."
  (interactive "r")
  (let ((text (buffer-substring-no-properties start end)))
    (with-current-buffer "*vterm*" (vterm-send-string text))
  )
)

(leader
  "t n" #'vterm
  "t s" #'vterm-send-region
)
;; terminal stuff end
