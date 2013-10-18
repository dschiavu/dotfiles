;; ~/.emacs
;;

;; TODO:
;; https://github.com/bbatsov/prelude
;; http://wikemacs.org/index.php/Main_Page
;; http://www.emacswiki.org/
;; https://github.com/bbatsov/zenburn-emacs

;; TODO: CC-MODE
;; Emacs 23 change font size: C-x C-+, C-x C--
;;

(require 'twittering-mode)

;;
;; visual
;;
(set-background-color "gray15") ;; was gray15
(set-foreground-color "white") ;; for X11 emacs, birghtgreen is also cool
;;(set-foreground-color "lightwhite") ;; for console

;;
;; postavke boja za konzolu:
;; 
;; u direktorij:
;; /usr/loca/share/emacs/site-lisp
;; staviti file naziva tip-terminala.el
;; i emacs ce ga izvrsiti ovisno u kojem se TERM-u nalazimo!
;; korisno za podesavanje boja kad je emacs u konzoli a ne GUI!
;;
;; !!! vidi opis kako radi u /usr/share/emacs/verzija/lisp/term/README !!!!!

;(set-background-color "white")
;(set-foreground-color "black")
;;M-x customize-face RET scroll-bar RET

; start emacs fullscreen
; doesn't work -- use "-mm" switch
(add-to-list 'initial-frame-alist `(fullscreen . fullheight))
(add-to-list 'default-frame-alist `(fullscreen . fullheight))

(show-paren-mode 1)
;;(global-hl-line-mode 1)
(set-face-background 'scroll-bar "gray13")

(setq font-lock-maximum-decoration t)

;; tab width
(setq default-tab-width 4)

(setq fill-width 120)

;; cc-mode
(setq c-basic-offset 4)

(line-number-mode 1)
(column-number-mode 1)

;; set UTF8 default coding
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(setq visible-bell t)

;; visual

;;***** (set-default-font "Inconsolata 11")
(set-default-font "Consolas 10")
;;(set-default-font "Consolas Bold 10")
;;(set-default-font "Ubuntu Mono 12")
;;(set-default-font "Ubuntu Mono Bold 12")
;;(set-default-font "Source Sans Pro 11")
;;***   (set-default-font "Fixedsys Excelsior 3.01 12")
;;(set-default-font "Roboto Medium 11")
;;(set-default-font "Roboto Bold 11")
;;(set-default-font "Roboto Bold Condensed 11")
;;****  (set-default-font "Dejavu Sans Mono 9")
;;***** (set-default-font "Droid Sans Mono 10")
;;****  (set-default-font "Lucida Console 11")
;;***** (set-default-font "Consolas 10")
;; (set-default-font "Lucida Sans Typewriter 10")
;; (set-default-font "Nimbus Mono L 11")
;; (set-default-font "Source Code Pro 11")
;; (set-default-font "Source Code Pro Bold 11")
;;**    (set-default-font "Source Sans Pro 11")
;; (set-default-font "Andale Mono 10")
;;***** (set-default-font "Anonymous Pro 11") 
;; (set-default-font "Courier New 10")

;;(tool-bar-mode)
(set-scroll-bar-mode "right")

(setq inhibit-startup-screen 1)

;; mouse text size zoom
(global-set-key [C-mouse-4] 'text-scale-increase)
(global-set-key [C-mouse-5] 'text-scale-decrease)

;;
;; Hide splash-screen and startup-message
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

(defun toggle-full-screen ()
  "Toggles full-screen mode for Emacs window on Win32."
  (interactive)
  ;;(shell-command "emacs_fullscreen.exe")
  )

(defun toggle-bars ()
  "Toggles bars visibility."
  (interactive)
  ;;(menu-bar-mode)
  (tool-bar-mode))
  ;;(scroll-bar-mode))

(defun toggle-full-screen-and-bars ()
  "Toggles full-screen mode and bars."
  (interactive)
  (toggle-bars)
  (toggle-full-screen))

;; Use F11 to switch between windowed and full-screen modes
(global-set-key [f11] 'toggle-full-screen-and-bars)

;; Switch to full-screen mode during startup
(toggle-full-screen-and-bars)

;; full screen END

;; Associate buffer names with modes
(add-to-list 'auto-mode-alist '("\\.json\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode t)
            (setq tab-width 4)))
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(show-paren-mode t)
 '(text-scale-mode-step 1.2)
 '(tool-bar-mode nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(scroll-bar ((t (:background "gray13" :inverse-video t :width normal)))))

;;
;; Dired
;;
;; http://ergoemacs.org/emacs/emacs_dired_open_file_in_ext_apps.html
;;
(defun ergoemacs-open-in-external-app ()
  "Open the current file or dired marked files in external app."
  (interactive)
  (let ( doIt
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           (t (list (buffer-file-name))) ) ) )

    (setq doIt (if (<= (length myFileList) 5)
                   t
                 (y-or-n-p "Open more than 5 files?") ) )

    (when doIt
      (cond
       ((string-equal system-type "windows-nt")
        (mapc (lambda (fPath) (w32-shell-execute "open" (replace-regexp-in-string "/" "\\" fPath t t)) ) myFileList)
        )
       ((string-equal system-type "darwin")
        (mapc (lambda (fPath) (shell-command (format "open \"%s\"" fPath)) )  myFileList) )
       ((string-equal system-type "gnu/linux")
        (mapc (lambda (fPath) (let ((process-connection-type nil)) (start-process "" nil "xdg-open" fPath)) ) myFileList) ) ) ) ) )

(defun ergoemacs-open-in-desktop ()
  "Show current file in desktop (OS's file manager)."
  (interactive)
  (cond
   ((string-equal system-type "windows-nt")
    (w32-shell-execute "explore" (replace-regexp-in-string "/" "\\" default-directory t t)))
   ((string-equal system-type "darwin") (shell-command "open ."))
   ((string-equal system-type "gnu/linux")
    (let ((process-connection-type nil)) (start-process "" nil "xdg-open" "."))
    ;; (shell-command "xdg-open .") ;; 2013-02-10 this sometimes froze emacs till the folder is closed. ⁖ with nautilus
    ) ))

;;
;; Core functions
;;

;;
;; http://emacsredux.com/blog/2013/03/30/kill-other-buffers/
(defun kill-other-buffers ()
  "Kill all buffers but the current one.
Don't mess with special buffers."
  (interactive)
  (dolist (buffer (buffer-list))
    (unless (or (eql buffer (current-buffer)) (not (buffer-file-name buffer)))
      (kill-buffer buffer))))

;(global-set-key (kbd "C-c k") 'kill-other-buffers)

;;
;; http://emacsredux.com/blog/2013/03/30/kill-other-buffers/
(defun kill-buffer-other-window () (interactive) (kill-buffer (window-buffer (next-window))))

(global-set-key (kbd "C-c k") 'kill-buffer-other-window)