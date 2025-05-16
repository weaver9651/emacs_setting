;;; init-local.el --- my init -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; set el files load path
(setq load-path (cons (expand-file-name "~/.emacs.d/lisp") load-path))

;; straight.el
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

;; redo
(require 'redo+)
(global-set-key (kbd "C-x u") 'redo)
(setq undo-no-redo t)

;;;; ETC
;; buffer-navigation, find-file extension

;; emacs shell mode. previously f8, but now neotree.
(global-set-key (kbd "C-<f1>") 'shell)

;; show column (row, column) numbers
(column-number-mode 1)

;; Empty and kill redundant buffers on startup
(setq-default message-log-max nil)
(setq initial-scratch-message "")
(setq inhibit-startup-message t) ;; Remove "GNU Emacs" buffer
(kill-buffer "*Messages*")
(kill-buffer "*scratch*")

;; show the name of the command
;; (defun my-echo-command-name-hook ()
;;   (unless (or (eq this-command 'self-insert-command)
;; 	      (eq this-command 'next-line))
;;     (message "%s" this-command)))
;; (add-hook 'post-command-hook 'my-echo-command-name-hook)

;; time
(display-time)

;; parenthesis
(show-paren-mode 1)

;; show a menu only when running within X (save real estate when in console)
(menu-bar-mode (if window-system 1 -1))

;; reverse window
(defun other-window-reverse ()
  (interactive)
  (other-window -1))

(global-set-key (kbd "C-x .") 'other-window)
(global-set-key (kbd "C-x ,") 'other-window-reverse)

;; Toggle window dedication
(defun toggle-window-dedicated ()
  "Toggle whether the current active window is dedicated or not"
  (interactive)
  (message
   (if (let (window (get-buffer-window (current-buffer)))
	 (set-window-dedicated-p window
				 (not (window-dedicated-p window))))
       "Window '%s' is dedicated"
     "Window '%s' is normal")
   (current-buffer)))

;; Even window sizes
(advice-add 'split-window-horizontally :after (lambda (&rest args) (balance-windows)))
(advice-add 'delete-window :after (lambda (&rest args) (balance-windows)))


;; show buffer list in current window
(global-set-key (kbd "C-x b") 'buffer-menu)
(global-set-key (kbd "C-x C-b") 'ivy-switch-buffer)

;; copy to clipboard ;; only works for window mode not terminal mode
(setq x-select-enable-clipboard t)

;; copy to clipboard
(defun copy-to-clipboard ()
  (interactive)
  (if (display-graphic-p)
      (progn
        (message "Yanked region to x-clipboard!")
        (call-interactively 'clipboard-kill-ring-save)
        )
    (if (region-active-p)
        (progn
          (shell-command-on-region (region-beginning) (region-end) "xsel -i -b")
          (message "Yanked region to clipboard!")
          (deactivate-mark))
      (message "No region active; can't yank to clipboard!")))
  )

(defun paste-from-clipboard ()
  (interactive)
  (if (display-graphic-p)
      (progn
        (clipboard-yank)
        (message "graphics active")
        )
    (insert (shell-command-to-string "xsel -o -b"))
    )
  )

;; (global-set-key [f8] 'copy-to-clipboard)
;; (global-set-key [f9] 'paste-from-clipboard)

;;;;

;; gud-gdb
(global-set-key [f5] 'gud-continue)
(global-set-key [f10] 'gud-next)
(global-set-key [f11] 'gud-step)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-face-tag ((t (:inherit custom-variable-tag :foreground "black"))))
 '(diff-added ((t (:foreground "green"))))
 '(diff-context ((t (:weight bold))))
 '(diff-file-header ((t (:background "black" :weight bold))))
 '(diff-header ((t (:background "black"))))
 '(diff-hunk-header ((t (:foreground "cyan"))))
 '(diff-indicator-added ((t (:foreground "green"))))
 '(diff-indicator-removed ((t (:foreground "red"))))
 '(diff-removed ((t (:foreground "red"))))
 '(font-lock-function-name-face ((t (:foreground "cyan"))))
 '(highlight-indentation-face ((t (:inherit fringe :background "brightblack"))))
 '(magit-diff-added-highlight ((t (:foreground "green"))))
 '(magit-diff-context-highlight ((t (:foreground "grey50"))))
 '(magit-diff-removed-highlight ((t (:foreground "red"))))
 '(magit-section-highlight ((t (:background "cyan" :foreground "black"))))
 '(minibuffer-prompt ((t (:foreground "cyan"))))
 '(neo-dir-link-face ((t (:foreground "cyan"))))
 '(neo-file-link-face ((t (:foreground "white"))))
 '(neo-vc-default-face ((t (:foreground "#e5e5e5"))))
 '(tuareg-font-lock-interactive-output-face ((t (:foreground "cyan")))))

;; ivy-mode
(use-package counsel
  :ensure t
  :config
  (ivy-mode))

;; neotree
;; (use-package neotree
;;   :ensure t
;;   :config
;;   (global-set-key [f8] 'neotree-toggle))

;;;; treemacs
(use-package treemacs
  :ensure t
  :bind
  ("<f8>" . treemacs)
  (:map treemacs-mode-map
        ("SPC" . treemacs-TAB-action))
  )

(use-package nerd-icons
  :ensure t
  ;; :custom
  ;; The Nerd Font you want to use in GUI
  ;; "Symbols Nerd Font Mono" is the default and is recommended
  ;; but you can use any other Nerd Font if you want
  ;; (nerd-icons-font-family "Symbols Nerd Font Mono")
  )

(use-package treemacs-nerd-icons
  :after (treemacs nerd-icons)
  :config
  (treemacs-load-theme "nerd-icons"))
;;;;

;; treesitter
(use-package treesit
  :ensure nil
  :when (treesit-available-p)
  :init
  (setq major-mode-remap-alist
	'((python-mode . python-ts-mode)
	  (yaml-mode . yaml-ts-mode)
	  (ocaml-mode . ocaml-ts-mode))))

(use-package treesit-auto
  :ensure t
  :config
  (global-treesit-auto-mode))

;; eglot
(add-hook 'prog-mode-hook 'eglot-ensure)
(global-set-key [f2] 'eglot-rename)


;;;; ocmal
;; tuareg
(use-package tuareg
  :ensure t)

;; ocamlformat
(use-package ocamlformat
  :ensure t
  :bind ("<f6>" . ocamlformat)
  :custom (ocamlformat-enable 'enable-outside-detected-project))

;; merlin
(let ((opam-share (ignore-errors (car (process-lines "opam" "var" "share")))))
  (when (and opam-share (file-directory-p opam-share))
    ;; Register Merlin
    (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))
    (autoload 'merlin-mode "merlin" nil t nil)
    ;; Automatically start it in OCaml buffers
    (add-hook 'tuareg-mode-hook 'merlin-mode t)
    (add-hook 'caml-mode-hook 'merlin-mode t)
    ;; Use opam switch to lookup ocamlmerlin binary
    (setq merlin-command 'opam)
    ;; To easily change opam switches within a given Emacs session, you can
    ;; install the minor mode https://github.com/ProofGeneral/opam-switch-mode
    ;; and use one of its "OPSW" menus.
    ))

;;;;

;; projectile
(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :config
  (setq projectile-completion-system 'ivy)
  :bind (:map projectile-mode-map
	      ("s-p" . projectile-command-map)   ;; for MacOS
	      ("C-c p" . projectile-command-map) ;; for Windows/Linux
	      ))

;; tab-bar
(use-package tab-bar
  :ensure nil
  :init
  (tab-bar-mode 1)
  :config
  (setq tab-bar-show 1)
  (setq tab-bar-close-button-show nil)
  (setq tab-bar-tab-hints t)
  (setq tab-bar-format '(tab-bar-format-tabs tab-bar-separator)))
(global-set-key (kbd "M-{") 'tab-bar-switch-to-prev-tab)
(global-set-key (kbd "M-}") 'tab-bar-switch-to-next-tab)
(global-set-key (kbd "M-t") 'tab-bar-new-tab)
(global-set-key (kbd "M-W") 'tab-bar-close-tab)
(global-set-key (kbd "C-x M-{") 'tab-bar-move-tab-backward)
(global-set-key (kbd "C-x M-}") 'tab-bar-move-tab)

;; override compilation keybinding
(with-eval-after-load 'compile
  (define-key compilation-mode-map (kbd "M-{") 'tab-bar-switch-to-prev-tab)
  (define-key compilation-mode-map (kbd "M-}") 'tab-bar-switch-to-next-tab))

(add-hook 'window-setup-hook #'tab-bar-mode) ;; To force tabs appear

;; corfu ;; included in Purcell emacs
;; (use-package corfu
;;   :ensure t
;;   :init
;;   (global-corfu-mode))

;; magit
(use-package magit
  :ensure t)
(global-set-key (kbd "C-x g") 'magit-status)

;; highlight git diff
(diff-hl-margin-mode)

;; copilot
(when (executable-find "node")
  (use-package copilot
    :straight (:host github :repo "copilot-emacs/copilot.el" :files ("*.el"))
    :ensure t
    :hook (prog-mode . copilot-mode)
    :bind (:map copilot-completion-map
                ("<tab>" . copilot-accept-completion)
                ("TAB" . copilot-accept-completion)
                ("C-c C-a" . copilot-accept-completion-by-word))
    :config
    (add-to-list 'copilot-indentation-alist '(prog-mode . 2))
    (add-to-list 'copilot-indentation-alist '(org-mode . 2))
    (add-to-list 'copilot-indentation-alist '(text-mode . 2))
    (add-to-list 'copilot-indentation-alist '(closure-mode . 2))
    (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode . 2))))
(setq warning-minimum-level :error)

;; suppress automatic popup
;; (with-eval-after-load 'lsp-mode
;;   (setq lsp-eldoc-enable-hover nil))

(provide 'init-local)

;;; init-local.el ends here
