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

(straight-use-package 'company-mode)

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
(setq lsp-log-io t)
(setq lsp-headerline-breadcrumb-enable nil)
;; lsp stuff end

;; rust stuff start 
(straight-use-package 'rust-mode)
(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil) (lsp-deferred)))
;; rust stuff end

;; ;; c/c++ stuff start

;; (defun run-rad-debugger () ;;@WINDOWS-ONLY ;;@OS-SPECIFIC
;;   (interactive)
;;   (let*
;;       ;; variables
;;       (
;;        (root (project-root (project-current t)))
;;        (default-directory root)
;;        (dbg (expand-file-name "dbg.bat" root))
;;       )
;;     (if (file-exists-p dbg)
;;        (shell-command dbg)
;;        (message "no dbg.bat found in %s" root)
;;     )
;;   )
;; )

;; (add-hook 'c-mode-hook (lambda () (lsp-deferred)))
;; (add-hook 'c++-mode-hook (lambda ()   (setq lsp-clients-clangd-executable "clangd")   (setq lsp-clients-clangd-args '("--query-driver=/**/bin/xtensa-esp32-elf-*" "--background-index" "--header-insertion=iwyu" "-j=4" )) (lsp-deferred)))








;; ;; c/c++ stuff start

(defun my-c-c++-setup ()
  ;; Use normal Emacs/cc-mode indentation.
  ;; Do NOT let lsp-mode/clangd format or indent code.
  (setq-local lsp-enable-on-type-formatting nil)
  (setq-local lsp-enable-indentation nil)

  ;; Normal C/C++ indentation settings.
  (setq-local c-basic-offset 4)
  (setq-local indent-tabs-mode nil)

  ;; Start clangd/LSP.
  (setq-local lsp-clients-clangd-executable "clangd")
  (setq-local lsp-clients-clangd-args
              '("--query-driver=/**/bin/xtensa-esp32-elf-*"
                "--background-index"
                "--header-insertion=iwyu"
                "-j=4"))
  (lsp-deferred))

(add-hook 'c-mode-hook #'my-c-c++-setup)
(add-hook 'c++-mode-hook #'my-c-c++-setup)


(defun run-rad-debugger ()
  (interactive)
  (let* ((root (project-root (project-current t)))
         (default-directory root)
         (dbg (expand-file-name "dbg.bat" root)))
    (if (file-exists-p dbg)
        (shell-command dbg)
      (message "no dbg.bat found in %s" dbg))))


;; c/c++ stuff end

;; c/c++ stuff end








;; generic start
(toggle-debug-on-error)
(electric-pair-mode 1)
;; (electric-indent-mode 1)
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
(straight-use-package 'pyvenv)
(require 'lsp-pyright)
(require 'pyvenv)
(pyvenv-mode 1)

;; (setq lsp-pyright-python-executable-cmd
;;       "/home/mohamed/environments/manim/bin/python")

(add-hook 'python-mode-hook (lambda ()
			      (pyvenv-activate "/home/mohamed/environments/manim")
			      (lsp-deferred)
			      (flymake-mode -1)
			      )) 


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
;; (straight-use-package 'erlang)
;; ;; (setq lsp-enable-on-type-formatting nil)

;; /home/mohamed/tools/otp_src_29.0.3/lib/tools/emacs
(defun my-erlang-align-end ()
  (when (and (derived-mode-p 'erlang-mode)
	     (looking-back "\\_<end[.,;]" (line-beginning-position)))
    (save-excursion
      (let ((beg (progn (erlang-beginning-of-clause) (point)))
            (end (line-end-position)))
        (indent-region beg end)))))


(add-hook 'post-self-insert-hook #'my-erlang-align-end)
(add-to-list 'load-path "/home/mohamed/tools/otp_src_29.0.3/lib/tools/emacs")
(setq erlang-root-dir "/home/mohamed/tools/otp_src_29.0.3")
(add-to-list 'exec-path "/home/mohamed/tools/otp_src_29.0.3/bin")
(require 'erlang-start)
(add-hook 'erlang-mode-hook (lambda () (message "lsp for erlang should be started where is it looking i have no idea")  (lsp-deferred)))
;; erlang stuff end

;; zig stuff start
(straight-use-package 'zig-mode)
(require 'zig-mode)
(add-hook 'zig-mode-hook #'lsp-deferred)
;; zig stuff end


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

(defun my-verilog-setup ()
  (setq-local verilog-indent-level 4)
  (setq-local verilog-indent-level-module 4)
  (setq-local verilog-indent-level-declaration 4)
  (setq-local verilog-indent-level-behavioral 4)
  (setq-local verilog-indent-level-directive 4)
  (setq-local verilog-case-indent 4)
  (setq-local verilog-auto-newline nil)
  (setq-local verilog-auto-indent-on-newline t)
  (setq-local verilog-tab-always-indent t)
  (setq-local verilog-auto-lineup 'all)
  (setq-local verilog-highlight-p1800-keywords t)
  (setq-local verilog-highlight-modules t)
  (setq-local verilog-highlight-grouping-keywords t)
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width 24)
  )



(defun my-verilog-auto-close-begin ()
  (when (and (derived-mode-p 'verilog-mode)
             (eq last-command-event ?n)
             (looking-back "\\_<begin\\_>" (line-beginning-position)))
    (newline-and-indent)
    (save-excursion
      (newline)
      (insert "end")
      (indent-according-to-mode))))

(add-hook 'post-self-insert-hook #'my-verilog-auto-close-begin)

(add-hook 'verilog-mode-hook (lambda ()
			       (my-verilog-setup)
			       (lsp-deferred)
			      ))

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
;; @HACK
(add-to-list 'exec-path "/home/mohamed/tools/zls/zig-out/bin")



;;; experiments start
;;; experiments end
