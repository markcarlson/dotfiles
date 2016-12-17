(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

(load-file "~/.emacs.d/ui.el")
(load-file "~/.emacs.d/gimme-cat.el")
(load-file "/usr/local/share/emacs/site-lisp/cask/cask.el")
(require 'cask)
(cask-initialize)
(require 'pallet)
(pallet-mode t)

(require 'indent-guide)
(indent-guide-global-mode)
(setq indent-guide-recursive t)
(setq indent-guide-char "|")

(defun my-frame-config (frame)
  "Custom behaviours for new frames."
  (with-selected-frame frame
    (when (display-graphic-p)
      (scroll-bar-mode -1))))
;; run now
(my-frame-config (selected-frame))
;; and later
(add-hook 'after-make-frame-functions 'my-frame-config)

;; MAIN Configs
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq ring-bell-function 'ignore)
(tool-bar-mode -1)
(menu-bar-mode -1)
(global-hl-line-mode 1)
(global-git-gutter-mode t)
(git-gutter:linum-setup)
(setq tab-width 2)
(ac-config-default)
(global-auto-complete-mode t)
(setq inhibit-splash-screen t)
(set-default-font "-*-Lucida Grande-normal-normal-normal-*-*-*-*-*-p-0-iso10646-1")
(setq-default indent-tabs-mode nil)
(setq multi-term-program-switches "--login")
(setq sunshine-location "Seattle,WA")
(setq initial-major-mode (quote text-mode))
(global-linum-mode t)
(setq linum-format " %d  ")
(setq magit-auto-revert-mode nil)
(setq magit-last-seen-setup-instructions "1.4.0")
(global-set-key [f8] 'neotree-toggle)
(ac-config-default)
(global-auto-complete-mode t)
(elpy-enable)
(global-set-key "\C-c\k" 'gimme-cat)

;; Popwin
(autoload 'popwin-mode "popwin" nil t)
(popwin-mode 1)

;; popwin settings
(setq popwin:special-display-config
      '(("*Help*" :height 30 :stick t)
        ("*Completions*" :noselect t)
        ("*compilation*" :noselect t)
        ("*Messages*")
        ("*Occur*" :noselect t)
        ("*magit: emacs*" :noselect t :height 20 :width 80)
        ("*magit-commit*" :noselect t :height 20 :width 80)
        ("COMMIT_EDITMSG" :noselect t :height 5 :width 80)
        ("*magit-diff*" :noselect t :height 30 :width 80)
        ("*magit-edit-log*" :noselect t :height 15 :width 80)
        ("*magit-process*" :noselect t :height 15 :width 80)
        ;;("*eshell*" :height 20)
        ("*Kill Ring*" :height 30)
        ("*Compile-Log" :height 20 :stick t)
        ))

(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/themes/"))
(add-to-list 'auto-mode-alist '("\\.rkt$" . racket-mode))
(autoload 'enh-ruby-mode "enh-ruby-mode" "Major mode for ruby files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("\\.erb$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.feature$" . feature-mode))
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("\\.php$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.exs$" . elixir-mode))
(add-to-list 'auto-mode-alist '("\\.slim$" . slim-mode))
(add-to-list 'auto-mode-alist '("\\.p[lm]$" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.less$" . less-css-mode))

(add-hook 'racket-mode-hook
          '(lambda ()
             (define-key racket-mode-map (kbd "C-c r") 'racket-run)))

;; KeyFreq
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)

;; Multiple Cursors
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)


;; Project Management
(projectile-global-mode)
;(projectile-rails-mode)
(setq projectile-completion-system 'grizzl)

;; Paren stuff
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)
(rainbow-delimiters-mode)
(show-paren-mode 1)
(electric-pair-mode 1)

;; Perl stuff
(eval-after-load 'cperl-mode
  '(progn
     (define-key cperl-mode-map (kbd "RET") 'reindent-then-newline-and-indent)
     (define-key cperl-mode-map (kbd "C-M-h") 'backward-kill-word)))

(global-set-key (kbd "C-h P") 'perldoc)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Keys & Menus:
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;###autoload
(progn
  (autoload 'inline-string-rectangle "inline-string-rectangle")
  (global-set-key (kbd "C-x C-b") 'bs-show))

(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-c d") 'delete-line)
(global-set-key (kbd "C-c n") 'new-empty-buffer)
(global-set-key (kbd "C-c u") 'reset-ui)
(global-set-key (kbd "C-c t") 'toggle-eshell-visor)


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Custom Functions:
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun new-empty-buffer ()
  "Open a new empty buffer."
  (interactive)
  (let ((buf (generate-new-buffer "untitled")))
    (switch-to-buffer buf)
    (funcall (and initial-major-mode))
    (setq buffer-offer-save t)))

  ;;indent/unindent
  ;;http://stackoverflow.com/a/11624677
  (defun my-indent-region (N)
  (interactive "p")
  (if (use-region-p)
      (progn (indent-rigidly (region-beginning) (region-end) (* N 2))
             (setq deactivate-mark nil))
    (self-insert-command N)))

  (defun my-unindent-region (N)
    (interactive "p")
    (if (use-region-p)
	(progn (indent-rigidly (region-beginning) (region-end) (* N -2))
	       (setq deactivate-mark nil))
      (self-insert-command N)))

  (global-set-key ">" 'my-indent-region)
  (global-set-key "<" 'my-unindent-region)

;; make backup to a designated dir, mirroring the full path

(setq auto-save-default nil)
(defun my-backup-file-name (fpath)
  "Return a new file path of a given file path.
If the new path's directories does not exist, create them."
  (let* (
        (backupRootDir "~/.emacs.d/emacs-backup/")
        (filePath (replace-regexp-in-string "[A-Za-z]:" "" fpath )) ; remove Windows driver letter in path, ⁖ “C:”
        (backupFilePath (replace-regexp-in-string "//" "/" (concat backupRootDir filePath "~") ))
        )
    (make-directory (file-name-directory backupFilePath) (file-name-directory backupFilePath))
    backupFilePath
  )
)

(setq make-backup-file-name-function 'my-backup-file-name)

;;Fullscreen
(defun toggle-fullscreen (&optional f)
  (interactive)
  (let ((current-value (frame-parameter nil 'fullscreen)))
    (set-frame-parameter nil 'fullscreen
                         (if (equal 'fullboth current-value)
                             (if (boundp 'old-fullscreen) old-fullscreen nil)
                           (progn (setq old-fullscreen current-value)
                                  'fullboth)))))

(global-set-key [f12] 'toggle-fullscreen)

(defun cursor-shape-hook ()
    (if (equal (thing-at-point 'line) "\n") (setq cursor-type 'bar)
       (setq cursor-type 'box)))

(add-hook 'post-command-hook 'cursor-shape-hook)

(defun bury-compile-buffer-if-successful (buffer string)
  "Bury a compilation buffer if succeeded without warnings "
  (if (and
       (string-match "compilation" (buffer-name buffer))
       (string-match "finished" string)
       (not
        (with-current-buffer buffer
          **(goto-char 1)**
          (search-forward "warning" nil t))))
      (run-with-timer 1 nil
                      (lambda (buf)
                        (bury-buffer buf)
                        (switch-to-prev-buffer (get-buffer-window buf) 'kill))
                      buffer)))
(add-hook 'compilation-finish-functions 'bury-compile-buffer-if-successful)

(setq erc-hide-list '("JOIN" "PART" "QUIT"))

(defun prev-window ()
   (interactive)
   (other-window -1))

 (define-key global-map (kbd "C-x p") 'prev-window)

;; CUSTOM CONFIG
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#272822" "#F92672" "#A6E22E" "#E6DB74" "#66D9EF" "#FD5FF0" "#A1EFE4" "#F8F8F2"])
 '(blink-cursor-mode nil)
 '(coffee-tab-width 4)
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-enabled-themes (quote (seti)))
 '(custom-safe-themes
   (quote
    ("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "94ba29363bfb7e06105f68d72b268f85981f7fba2ddef89331660033101eb5e5" "4f5bb895d88b6fe6a983e63429f154b8d939b4a8c581956493783b2515e22d6d" "3d5ef3d7ed58c9ad321f05360ad8a6b24585b9c49abcee67bdcbb0fe583a6950" "e9776d12e4ccb722a2a732c6e80423331bcb93f02e089ba2a4b02e85de1cf00e" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "118717ce0a2645a0cf240b044999f964577ee10137b1f992b09a317d5073c02d" "05c3bc4eb1219953a4f182e10de1f7466d28987f48d647c01f1f0037ff35ab9a" "0c29db826418061b40564e3351194a3d4a125d182c6ee5178c237a7364f0ff12" "ac2b1fed9c0f0190045359327e963ddad250e131fbf332e80d371b2e1dbc1dc4" "b32395a616bbb47d046772e901c7868bbe05a02e2e76ba42db6c121b1565bd04" "4e262566c3d57706c70e403d440146a5440de056dfaeb3062f004da1711d83fc" "b7d8113de2f7d9a3cf42335d8eed8415b5a417e7f6382e59076f9f4ae4fa4cee" "b73c22111068f51f332cf73ea2eae196b2377c3218054c1bcd436e27e5eeac3e" "1d9492749ca290d1702b2f331b99a2692cda19fb1e4aae4b9e75515027afbf3b" "57f8801351e8b7677923c9fe547f7e19f38c99b80d68c34da6fa9b94dc6d3297" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(ensime-sem-high-faces
   (quote
    ((var :foreground "#9876aa" :underline
          (:style wave :color "yellow"))
     (val :foreground "#9876aa")
     (varField :slant italic)
     (valField :foreground "#9876aa" :slant italic)
     (functionCall :foreground "#a9b7c6")
     (implicitConversion :underline
                         (:color "#808080"))
     (implicitParams :underline
                     (:color "#808080"))
     (operator :foreground "#cc7832")
     (param :foreground "#a9b7c6")
     (class :foreground "#4e807d")
     (trait :foreground "#4e807d" :slant italic)
     (object :foreground "#6897bb" :slant italic)
     (package :foreground "#cc7832")
     (deprecated :strike-through "#a9b7c6"))))
 '(fci-rule-color "#49483E")
 '(highlight-changes-colors (quote ("#FD5FF0" "#AE81FF")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#002b36" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors
   (quote
    (("#49483E" . 0)
     ("#67930F" . 20)
     ("#349B8D" . 30)
     ("#21889B" . 50)
     ("#968B26" . 60)
     ("#A45E0A" . 70)
     ("#A41F99" . 85)
     ("#49483E" . 100))))
 '(hl-bg-colors
   (quote
    ("#7B6000" "#8B2C02" "#990A1B" "#93115C" "#3F4D91" "#00629D" "#00736F" "#546E00")))
 '(hl-fg-colors
   (quote
    ("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36")))
 '(magit-diff-use-overlays nil)
 '(magit-use-overlays nil)
 '(menu-bar-mode nil)
 '(nrepl-message-colors
   (quote
    ("#dc322f" "#cb4b16" "#b58900" "#546E00" "#B4C342" "#00629D" "#2aa198" "#d33682" "#6c71c4")))
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(racket-program "~/Applications/Racket v6.1/bin/racket")
 '(show-paren-mode t)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(sr-speedbar-right-side nil)
 '(syslog-debug-face
   (quote
    ((t :background unspecified :foreground "#A1EFE4" :weight bold))))
 '(syslog-error-face
   (quote
    ((t :background unspecified :foreground "#F92672" :weight bold))))
 '(syslog-hour-face (quote ((t :background unspecified :foreground "#A6E22E"))))
 '(syslog-info-face
   (quote
    ((t :background unspecified :foreground "#66D9EF" :weight bold))))
 '(syslog-ip-face (quote ((t :background unspecified :foreground "#E6DB74"))))
 '(syslog-su-face (quote ((t :background unspecified :foreground "#FD5FF0"))))
 '(syslog-warn-face
   (quote
    ((t :background unspecified :foreground "#FD971F" :weight bold))))
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(tool-bar-mode nil)
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#F92672")
     (40 . "#CF4F1F")
     (60 . "#C26C0F")
     (80 . "#E6DB74")
     (100 . "#AB8C00")
     (120 . "#A18F00")
     (140 . "#989200")
     (160 . "#8E9500")
     (180 . "#A6E22E")
     (200 . "#729A1E")
     (220 . "#609C3C")
     (240 . "#4E9D5B")
     (260 . "#3C9F79")
     (280 . "#A1EFE4")
     (300 . "#299BA6")
     (320 . "#2896B5")
     (340 . "#2790C3")
     (360 . "#66D9EF"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (quote
    (unspecified "#272822" "#49483E" "#A20C41" "#F92672" "#67930F" "#A6E22E" "#968B26" "#E6DB74" "#21889B" "#66D9EF" "#A41F99" "#FD5FF0" "#349B8D" "#A1EFE4" "#F8F8F2" "#F8F8F0")))
 '(xterm-color-names
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#eee8d5"])
 '(xterm-color-names-bright
   ["#002b36" "#cb4b16" "#586e75" "#657b83" "#839496" "#6c71c4" "#93a1a1" "#fdf6e3"]))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil)))))
(defadvice yes-or-no-p (around prevent-dialog activate)
  "Prevent yes-or-no-p from activating a dialog"
  (let ((use-dialog-box nil))
    ad-do-it))
(defadvice y-or-n-p (around prevent-dialog-yorn activate)
  "Prevent y-or-n-p from activating a dialog"
  (let ((use-dialog-box nil))
    ad-do-it))
