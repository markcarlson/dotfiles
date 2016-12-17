;;default display position/size based on display resolution
;;warning: assumption that the 24/22 " displays are oriented
;;         above the laptop's display
;;         Haven't found a way to check multiple monitor
;;         relative orientation via emacs yet...
;;
;; a frame is passed in when firing on after-make-frame-fuctions,
;; but not necessary when calling interactively
(defun toggle-fullscreen ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

(defun reset-ui (&optional frame)
  (if frame
    (select-frame frame))
  (interactive)
  (smex-initialize)
  (load-theme 'seti t)
  (delete-other-windows)
  (set-cursor-color "deeppink")
  (set-face-background 'modeline-inactive "gray10")
  (toggle-fullscreen)
  (split-window-horizontally))

;; fires when an emacs frame is created (emacsclient)
;; invoke like this ( on osx):
;; emacsclient -c -n; osascript -e "tell application \"Emacs\" to activate"
(add-hook 'after-make-frame-functions 'reset-ui)

;; hook for setting up UI when not running in daemon mode
(add-hook 'emacs-startup-hook 'reset-ui)

(fset 'eshell-visor-on
      "\C-x1\M-xeshell\n")
(fset 'eshell-visor-off
      "\C-x3\M-xbury-buffer\n\C-xo\M-xbury-buffer\n\M-xswap-windows")

;; assumes using reset-ui based layout
(defun toggle-eshell-visor ()
  (interactive)
  (if (string= "eshell-mode" (eval 'major-mode))
      (execute-kbd-macro (symbol-function 'eshell-visor-off))
    (execute-kbd-macro (symbol-function 'eshell-visor-on))))
