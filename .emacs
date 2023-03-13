;  ______     __    __     ______     ______     ______    
; /\  ___\   /\ "-./  \   /\  __ \   /\  ___\   /\  ___\   
; \ \  __\   \ \ \-./\ \  \ \  __ \  \ \ \____  \ \___  \  
;  \ \_____\  \ \_\ \ \_\  \ \_\ \_\  \ \_____\  \/\_____\ 
;   \/_____/   \/_/  \/_/   \/_/\/_/   \/_____/   \/_____/ 
;                                                     par louis

;                           --------------------

;  ___         _  _    _         _  _              _    _               
; |_ _| _ __  (_)| |_ (_)  __ _ | |(_) ___   __ _ | |_ (_)  ___   _ __  
;  | | | '_ \ | || __|| | / _` || || |/ __| / _` || __|| | / _ \ | '_ \ 
;  | | | | | || || |_ | || (_| || || |\__ \| (_| || |_ | || (_) || | | |
; |___||_| |_||_| \__||_| \__,_||_||_||___/ \__,_| \__||_| \___/ |_| |_|

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))


(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "~/.emacs.d/lisp/powerline-master/")
(add-to-list 'load-path "~/.emacs.d/lisp/centaur-tabs-master/")
(add-to-list 'load-path "~/.emacs.d/lisp/term-keys/")
(add-to-list 'load-path "~/.emacs.d/themes/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(add-to-list 'exec-path "/Library/TeX/texbin")

(package-initialize)



;; (setq xterm-extra-capabilities 't)

(require 'term-keys)
(term-keys-mode t)
(require 'term-keys-konsole)
(with-temp-buffer
  (insert (term-keys/konsole-keytab))
  (append-to-file (point-min) (point-max) "~/.local/share/konsole/Emacs.keytab"))



;                           --------------------
;  _____      _  _  _    _                
; | ____|  __| |(_)| |_ (_) _ __    __ _  
; |  _|   / _` || || __|| || '_ \  / _` | 
; | |___ | (_| || || |_ | || | | || (_| | 
; |_____| \__,_||_| \__||_||_| |_| \__, | 
;                                  |___/ 

;; encoding
(prefer-coding-system 'utf-8-unix)

;; saving all buffers
;; (define-key global-map (kbd "C-x C-a") ')
(define-key global-map (kbd "C-x C-a") 'save-all)

(defun save-all ()
  (interactive)
  (let ((current-prefix-arg 4)) ;; emulate C-u
    (call-interactively 'save-some-buffers)
    )
  )


;  ___       _           _    _            
; / __| ___ | | ___  __ | |_ (_) ___  _ _  
; \__ \/ -_)| |/ -_)/ _||  _|| |/ _ \| ' \ 
; |___/\___||_|\___|\__| \__||_|\___/|_||_|

;; all selection
(define-key global-map (kbd "C-a") 'mark-whole-buffer)

;  _  _  _      _              _     
; | || |(_) ___| |_  ___  _ _ (_) __ 
; | __ || |(_-<|  _|/ _ \| '_|| |/ _|
; |_||_||_|/__/ \__|\___/|_|  |_|\__|

;; undo tree
(global-undo-tree-mode)
(define-key global-map (kbd "C-z") 'undo-tree-undo)
(define-key global-map (kbd "C-S-z") 'undo-tree-redo)

;  _  __ _  _  _  _             
; | |/ /(_)| || |(_) _ _   __ _ 
; | ' < | || || || || ' \ / _` |
; |_|\_\|_||_||_||_||_||_|\__, |
;                         |___/ 

;; CUA
(cua-mode t)

;; kill line
(defun backward-kill-line (arg)
  "Kill ARG lines backward."
  (interactive "p")
  (kill-line (- 1 arg)))

(define-key global-map (kbd "C-k") (lambda () (interactive) (kill-line 1) (yank)))
(define-key global-map (kbd "M-k") (lambda () (interactive) (backward-kill-line 1) (yank)))

;; kill sentence
(define-key global-map (kbd "C-;") (lambda () (interactive) (kill-sentence) (yank)))
(define-key global-map (kbd "M-;") (lambda () (interactive) (backward-kill-sentence) (yank)))

;; kill word
(define-key global-map (kbd "C-,") (lambda () (interactive) (kill-word 1) (yank)))
(define-key global-map (kbd "M-,") (lambda () (interactive) (backward-kill-word 1) (yank)))

;                           --------------------

;  ____   _              _               
; |  _ \ (_) ___  _ __  | |  __ _  _   _ 
; | | | || |/ __|| '_ \ | | / _` || | | |
; | |_| || |\__ \| |_) || || (_| || |_| |
; |____/ |_||___/| .__/ |_| \__,_| \__, |
;                |_|               |___/ 
;  ___             _                      _     _     _            
; | __| ___  _ _  | |_     __ _  _ _   __| |   | |   (_) _ _   ___ 
; | _| / _ \| ' \ |  _|   / _` || ' \ / _` |   | |__ | || ' \ / -_)
; |_|  \___/|_||_| \__|   \__,_||_||_|\__,_|   |____||_||_||_|\___|

;; colum and line numer
(setq column-number-mode t)

;; font
(set-frame-font "hack 15" nil t)

;; line wrap
(visual-line-mode t)
(global-visual-line-mode t)
;; (global-visual-line-mode 1)

;; line number
(require 'display-line-numbers)

(defcustom display-line-numbers-exempt-modes
  '(doc-view-mode)
  "Major modes on which to disable line numbers."
  :group 'display-line-numbers
  :type 'list
  :version "green")

(defun display-line-numbers--turn-on ()
  "Turn on line numbers except for certain major modes.
Exempt major modes are defined in `display-line-numbers-exempt-modes'."
  (unless (or (minibufferp)
              (member major-mode display-line-numbers-exempt-modes))
    (display-line-numbers-mode)))

(global-display-line-numbers-mode)

;; parenthesis
(show-paren-mode 1)
(setq show-paren-delay 0)


;    _          _        
;   /_\   _  _ | |_  ___ 
;  / _ \ | || ||  _|/ _ \
; /_/ \_\ \_,_| \__|\___/

;; color theme
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(beacon-color "#eab4484b8035")
 '(centaur-tabs-mode t nil (centaur-tabs))
 '(custom-enabled-themes (quote (apropospriate-dark)))
 '(custom-safe-themes
   (quote
    ("399180f9aeae0cd86623c54b61be9b7bb29a6d34b0ffc30d9a2c462c4e959d7b" "70f5a47eb08fe7a4ccb88e2550d377ce085fedce81cf30c56e3077f95a2909f2" "c3e6b52caa77cb09c049d3c973798bc64b5c43cc437d449eacf35b3e776bf85c" "5a0eee1070a4fc64268f008a4c7abfda32d912118e080e18c3c865ef864d1bea" default)))
 '(evil-emacs-state-cursor (quote ("#E57373" hbar)))
 '(evil-insert-state-cursor (quote ("#E57373" bar)))
 '(evil-normal-state-cursor (quote ("#FFEE58" box)))
 '(evil-visual-state-cursor (quote ("#C5E1A5" box)))
 '(highlight-indent-guides-auto-enabled nil)
 '(highlight-symbol-colors
   (quote
    ("#FFEE58" "#C5E1A5" "#80DEEA" "#64B5F6" "#E1BEE7" "#FFCC80")))
 '(highlight-symbol-foreground-color "#E0E0E0")
 '(highlight-tail-colors (quote (("#eab4484b8035" . 0) ("#424242" . 100))))
 '(latex-preview-pane-use-frame nil)
 '(package-selected-packages
   (quote
    (dired-ranger figlet diminish solaire-mode ivy-rich doom-themes centaur-tabs apropospriate-theme fill-column-indicator highlight-indent-guides tabbar transpose-frame ess highlight xclip auctex exec-path-from-shell latex-preview-pane loccur highlight-symbol undo-tree org htmlize)))
 '(pdf-latex-command "pdflatex")
 '(pos-tip-background-color "#3a513a513a51")
 '(pos-tip-foreground-color "#9E9E9E")
 '(shell-escape-mode "-shell-escape")
 '(tabbar-background-color "#353335333533"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hi-blue-b ((t (:foreground "light blue" :weight bold))))
 '(hi-green-b ((t (:foreground "light green" :weight bold))))
 '(hi-pink ((t (:background "light pink" :foreground "black"))))
 '(hi-red-b ((t (:foreground "tomato" :weight bold))))
 '(hi-yellow ((t (:background "light yellow" :foreground "black"))))
 '(hl-line ((t (:background "gray22" :underline nil :width normal)))))

;  _  _  _        _     _  _        _     _   
; | || |(_) __ _ | |_  | |(_) __ _ | |_  | |_ 
; | __ || |/ _` || ' \ | || |/ _` || ' \ |  _|
; |_||_||_|\__, ||_||_||_||_|\__, ||_||_| \__|
;          |___/             |___/            

;; highlight line
(global-hl-line-mode 1)
(set-face-attribute 'region nil :background "#777")

;; indentation line (too slow)
;; (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
;; (setq highlight-indent-guides-method 'character)


; __      __ _           _              
; \ \    / /(_) _ _   __| | ___ __ __ __
;  \ \/\/ / | || ' \ / _` |/ _ \\ V  V /
;   \_/\_/  |_||_||_|\__,_|\___/ \_/\_/ 

;; tool bar
(tool-bar-mode -1)

;; menu bar
 (menu-bar-mode -1)

;; dialog box
(setq use-dialog-box nil)

;; startup screen
(setq inhibit-startup-screen t)

;; zoom
;; (global-set-key [C-mouse-4] 'text-scale-increase)
;; (global-set-key [C-mouse-5] 'text-scale-decrease)
(add-hook 'doc-view-mode-hook (lambda () (global-set-key [C-mouse-4] 'doc-view-enlarge)))
(add-hook 'doc-view-mode-hook (lambda () (global-set-key [C-mouse-5] 'doc-view-shrink)))

;; window size
(setq default-frame-alist '((left . 0) (width . 86) (top . 0) (height . 42)))
;;(add-hook 'latex-mode-hook (lambda () (setq default-frame-alist '((left . 0) (width . 155) (top . 0) (height . 42)))))
;; (add-hook 'doc-view-mode-hook '(lambda () (set-frame-size (selected-frame) 165 42)))

;; solaire mode
(solaire-global-mode +1)

;; Remove info in modeline
(require 'diminish)
(diminish 'undo-tree-mode)


;   ___                          
;  / __| _  _  _ _  ___ ___  _ _ 
; | (__ | || || '_|(_-</ _ \| '_|
;  \___| \_,_||_|  /__/\___/|_|  

;; cursor
(xterm-mouse-mode 1)
(setq-default cursor-type 'bar)

(add-hook 'window-setup-hook '(lambda () (set-cursor-color "palegoldenrod")))
(add-hook 'after-make-frame-functions '(lambda (f) (with-selected-frame f (set-cursor-color "palegoldenrod"))))


;; TAB

(require 'centaur-tabs)
(centaur-tabs-mode t)
(global-set-key (kbd "M-<left>")  'centaur-tabs-backward)
(global-set-key (kbd "M-<right>") 'centaur-tabs-forward)
(centaur-tabs-headline-match)
;; (setq centaur-tabs-set-modified-marker t)
;; (setq centaur-tabs-modified-marker ".")




;                           --------------------

;  ____         _                    _              
; | __ )   ___ | |__    __ _ __   __(_)  ___   _ __ 
; |  _ \  / _ \| '_ \  / _` |\ \ / /| | / _ \ | '__|
; | |_) ||  __/| | | || (_| | \ V / | || (_) || |   
; |____/  \___||_| |_| \__,_|  \_/  |_| \___/ |_|   

;; dired
(defun dired-open-all-files ()
  (interactive)
  (dired-unmark-all-marks)
  (dired-toggle-marks)
  (dolist (f (dired-get-marked-files)) 
    (find-file f)))

(add-hook 'dired-load-hook
          (function (lambda () (load "dired-x") (define-key dired-mode-map (kbd "F") 'dired-open-all-files))))

(define-key global-map (kbd "C-x C-d") 'dired)
(define-key global-map (kbd "C-x C-r") 'find-name-dired)

;  ___                      
; / __| _ __  __ _  __  ___ 
; \__ \| '_ \/ _` |/ _|/ -_)
; |___/| .__/\__,_|\__|\___|
;      |_|      

;; new tab and ret
;; (define-key global-map (kbd "RET") 'electric-newline-and-maybe-indent)
(define-key global-map (kbd "RET") 'newline-and-indent)
(define-key global-map (kbd "TAB") 'indent-for-tab-command)

;  ___        _       _        
; |   \  ___ | | ___ | |_  ___ 
; | |) |/ -_)| |/ -_)|  _|/ -_)
; |___/ \___||_|\___| \__|\___|

;; selection delete when typing
(delete-selection-mode)

(defun my-syntax-class (char)
  "Return ?s, ?w or ?p depending or whether CHAR is a white-space, word or punctuation character."
  (pcase (char-syntax char)
    (`?\s ?s)
    (`?w ?w)
    (`?_ ?w)
    (_ ?p)))

(defun my-forward-word (&optional arg)
  "Move point forward a word (simulate behavior of Far Manager's editor).
With prefix argument ARG, do it ARG times if positive, or move backwards ARG times if negative."
  (interactive "^p")
  (or arg (setq arg 1))
  (let* ((backward (< arg 0))
         (count (abs arg))
         (char-next
          (if backward 'char-before 'char-after))
         (skip-syntax
          (if backward 'skip-syntax-backward 'skip-syntax-forward))
         (skip-char
          (if backward 'backward-char 'forward-char))
         prev-char next-char)
    (while (> count 0)
      (setq next-char (funcall char-next))
      (cl-loop
       (if (or                          ; skip one char at a time for whitespace,
            (eql next-char ?\n)         ; in order to stop on newlines
            (eql (char-syntax next-char) ?\s))
           (funcall skip-char)
         (funcall skip-syntax (char-to-string (char-syntax next-char))))
       (setq prev-char next-char)
       (setq next-char (funcall char-next))
       ;; (message (format "Prev: %c %c %c Next: %c %c %c"
       ;;                   prev-char (char-syntax prev-char) (my-syntax-class prev-char)
       ;;                   next-char (char-syntax next-char) (my-syntax-class next-char)))
       (when
           (or
            (eql prev-char ?\n)         ; stop on newlines
            (eql next-char ?\n)
            (and                        ; stop on word -> punctuation
             (eql (my-syntax-class prev-char) ?w))
             ;; (eql (my-syntax-class next-char) ?p))
            (and                        ; stop on word -> whitespace
             this-command-keys-shift-translated ; when selecting
             (eql (my-syntax-class prev-char) ?w)
             (eql (my-syntax-class next-char) ?s))
            (and                        ; stop on whitespace -> non-whitespace
             (not backward)             ; when going forward
             (not this-command-keys-shift-translated) ; and not selecting
             (eql (my-syntax-class prev-char) ?s)
             (not (eql (my-syntax-class next-char) ?s)))
            (and                        ; stop on non-whitespace -> whitespace
             backward                   ; when going backward
             (not this-command-keys-shift-translated) ; and not selecting
             (not (eql (my-syntax-class prev-char) ?s))
             (eql (my-syntax-class next-char) ?s))
            )
         (cl-return))
       )
      (setq count (1- count)))))

(defun delete-word (&optional arg)
  "Delete characters forward until encountering the end of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (my-forward-word arg) (point))))

(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-word (- arg)))

(defun my-backward-word (&optional arg)
  (interactive "^p")
  (or arg (setq arg 1))
  (my-forward-word (- arg)))

(global-set-key (kbd "C-<left>") 'my-backward-word)
(global-set-key (kbd "C-<right>") 'my-forward-word)
(global-set-key (kbd "C-<delete>") 'delete-word)
(global-set-key (kbd "C-<backspace>") 'backward-delete-word)

(defun delete-current-line ()
  "Delete (not kill) the current line."
  (interactive)
  (save-excursion
    (delete-region
     (progn (forward-visible-line 0) (point))
     (progn (forward-visible-line 1) (point)))))

(global-set-key (kbd "C-S-<backspace>") 'delete-current-line)



;  ___                _  _  _             
; / __| __  _ _  ___ | || |(_) _ _   __ _ 
; \__ \/ _|| '_|/ _ \| || || || ' \ / _` |
; |___/\__||_|  \___/|_||_||_||_||_|\__, |
;                                   |___/ 

;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(2 ((shift) . 2))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq scroll-preserve-screen-position 'always)

;; scroll bar
(set-scroll-bar-mode 'right)
(scroll-bar-mode -1)

;   ___  _  _        _                        _ 
;  / __|| |(_) _ __ | |__  ___  __ _  _ _  __| |
; | (__ | || || '_ \| '_ \/ _ \/ _` || '_|/ _` |
;  \___||_||_|| .__/|_.__/\___/\__,_||_|  \__,_|
;             |_|                               

;; xclip
(require 'xclip)
(xclip-mode 1)

;; enable clipboard in emacs
(setq x-select-enable-clipboard t)



;; window movement
;; (windmove-default-keybindings)
(global-set-key (kbd "<C-M-left>")  'windmove-left)
(global-set-key (kbd "<C-M-right>") 'windmove-right)
(global-set-key (kbd "<C-M-up>")    'windmove-up)
(global-set-key (kbd "<C-M-down>")  'windmove-down)


;; save session
;; (desktop-save-mode 1)


(setq ns-pop-up-frames nil)


;                           --------------------

;  _____                _      
; |_   _|  ___    ___  | | ___ 
;   | |   / _ \  / _ \ | |/ __|
;   | |  | (_) || (_) || |\__ \
;   |_|   \___/  \___/ |_||___/

;; renaming buffer 
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

(define-key global-map (kbd "C-x C-n") 'rename-file-and-buffer)

;   ___                                _   
;  / __| ___  _ __   _ __   ___  _ _  | |_ 
; | (__ / _ \| '  \ | '  \ / -_)| ' \ |  _|
;  \___|\___/|_|_|_||_|_|_|\___||_||_| \__|

;; comment
(define-key global-map (kbd "C-r") 'comment-line)
(setq comment-start "#")
;; (add-hook 'r-mode-hook (lambda () (setq comment-start "#")))


(add-hook 'ess-r-mode-hook
    (lambda () (progn (setq comment-start "# ")
                      (setq comment-add 0))))

;; # or ## or ### in the same place
(setq ess-fancy-comments nil)

;  _  _  _        _     _  _        _     _    _             
; | || |(_) __ _ | |_  | |(_) __ _ | |_  | |_ (_) _ _   __ _ 
; | __ || |/ _` || ' \ | || |/ _` || ' \ |  _|| || ' \ / _` |
; |_||_||_|\__, ||_||_||_||_|\__, ||_||_| \__||_||_||_|\__, |
;          |___/             |___/                     |___/ 


 
(defun loccur-empty ()
  (interactive)
  ;; (run-with-timer .2 nil 'insert 'delete-current-line)
  (let ((current-prefix-arg 4)) ;; emulate C-u
    (call-interactively 'loccur) ;; invoke align-regexp interactively
    ))

(defun loccur-summary ()
  (interactive)
  (run-with-timer .1 nil 'insert "##")
  (run-with-timer .2 nil 'execute-kbd-macro (kbd "RET"))
  (let ((current-prefix-arg 4)) ;; emulate C-u
    (call-interactively 'loccur) ;; invoke align-regexp interactively
    ))

;; loccur
;; highlight selection
(require 'loccur)
;; defines shortcut for loccur of the current word
(define-key global-map (kbd "C-o") 'loccur-current)
(define-key global-map (kbd "C-S-o") 'loccur-summary)
;; defines shortcut for the interactive loccur command
(define-key global-map (kbd "M-o") 'loccur-empty)


;; hi lock
(require 'hi-lock)  
(defun autohighlight-selection ()
  "..."
  (interactive)
  (cua-set-mark)
  (cua-set-mark)
  (if (boundp 'hi-lock-interactive-patterns)
      (unhighlight-regexp t))
  (if (use-region-p)
      (highlight-regexp (buffer-substring-no-properties (region-beginning) (region-end))))
)

(define-key global-map (kbd "C-w") 'autohighlight-selection)

;   ___                    _  _  _             
;  / __| ___  _ __   _ __ (_)| |(_) _ _   __ _ 
; | (__ / _ \| '  \ | '_ \| || || || ' \ / _` |
;  \___|\___/|_|_|_|| .__/|_||_||_||_||_|\__, |
;                   |_|                  |___/ 

;; C ret for compile all
(cua-mode t)
(defun compile-all (&optional arg)
  (interactive)
  (if (eq major-mode 'latex-mode)
      (TeX-command-run-all arg))
      ;; (TeX-texify))
  (if (eq major-mode 'ess-r-mode)
      ;; (ess-eval-buffer (point-min) (point-max) t))
      (ess-eval-buffer))
)

(define-key cua-global-keymap (kbd "C-<return>") #'compile-all)

;; C M ret for compile line and step
(cua-mode t)
(defun compile-line-and-step (&optional arg)
  (interactive)
  (if (eq major-mode 'ess-r-mode)
      (ess-eval-line-and-step))
)

(define-key cua-global-keymap (kbd "C-S-<return>") #'compile-line-and-step)


;  ___                      _    
; / __| ___  __ _  _ _  __ | |_  
; \__ \/ -_)/ _` || '_|/ _|| ' \ 
; |___/\___|\__,_||_|  \__||_||_|
                               
;; search and replace
(defun query-replace-region-or-from-top ()
  "If marked, query-replace for the region, else for the whole buffer (start from the top)"
  (interactive)
  (progn
    (let ((orig-point (point)))
      (if (use-region-p)
          (call-interactively 'query-replace)
        (save-excursion
          (goto-char (point-min))
          (call-interactively 'query-replace)))
      (message "Back to old point.")
      (goto-char orig-point))))

(define-key global-map (kbd "C-f") 'query-replace-region-or-from-top)


(defun query-replace-in-open-buffers (arg1 arg2)
  "query-replace in open files"
  (interactive "sQuery Replace in open Buffers: \nsquery with: ")
  (mapcar
   (lambda (x)
     (find-file x)
     (save-excursion
       (beginning-of-buffer)
       (query-replace arg1 arg2)))
   (delq
    nil
    (mapcar
     (lambda (x)
       (buffer-file-name x))
     (buffer-list)))))

;; (defun query-replace-region-or-from-top-ALL ()
;;   (interactive)
;;   (mapc (lambda (buffer)
;;           (condition-case nil
;;               (with-current-buffer buffer
;;                 (query-replace-region-or-from-top))
;;             (buffer-read-only nil)))
;;         (buffer-list)))

(define-key global-map (kbd "C-S-f") 'query-replace-in-open-buffers)
                   




(defun ascii-art-convert ()
  "Convert the current line of text to ascii art"
  (interactive)
  (let* ((line (buffer-substring (line-beginning-position) (line-end-position)))
         (string-line (concat line))
         (output-buf (generate-new-buffer "*figlet-output*"))
         (figlet-args (list "-f" "/home/louis/.emacs.d/fonts/small.flf" "-w" "80" string-line)))
    (apply 'call-process "figlet" nil output-buf nil figlet-args)
    (delete-region (line-beginning-position) (line-end-position))
    (insert-buffer-substring output-buf)
    (indent-according-to-mode)))

(global-set-key (kbd "C-c a") 'ascii-art-convert)





;                           --------------------

;   ___                                      _       
;  / _ \  _ __   __ _  _ __ ___    ___    __| |  ___ 
; | | | || '__| / _` || '_ ` _ \  / _ \  / _` | / _ \
; | |_| || |   | (_| || | | | | || (_) || (_| ||  __/
;  \___/ |_|    \__, ||_| |_| |_| \___/  \__,_| \___|
;               |___/                                
;  ___              _                   
; / __| _  _  _ _  | |_  __ _ __ __ ___ 
; \__ \| || || ' \ |  _|/ _` |\ \ // -_)
; |___/ \_, ||_||_| \__|\__,_|/_\_\\___|
;       |__/                            
                 
(fset 'org\#
      "#+")
(add-hook 'org-mode-hook (lambda () (global-set-key (kbd "M-#")  'org\#)))

;  _           _             
; | |    __ _ | |_  ___ __ __
; | |__ / _` ||  _|/ -_)\ \ /
; |____|\__,_| \__|\___|/_\_\

(add-hook 'org-mode-hook (lambda () (global-set-key (kbd "M-p") 'org-latex-export-to-pdf)))

(require 'org)
(setq org-highlight-latex-and-related '(latex script entities))

(with-eval-after-load 'ox-latex
   (add-to-list 'org-latex-classes
                '("basic"
                  "\\documentclass{cup-pan}
		  \\usepackage[utf8]{inputenc}
		  \\usepackage{blindtext}
		  \\usepackage{minted}
		  \\usepackage{float}
		  \\usepackage{upgreek}
		  \\usepackage{indentfirst}
		  \\usepackage[table]{xcolor}
		  \\usepackage{hyperref}
		  \\usepackage{wrapfig}
		  \\usepackage{gensymb}
		  \\usepackage{wasysym}
		  \\definecolor{mygray}{RGB}{251,251,251}
		  \\usepackage[position=bottom]{subfig}
		  \\usepackage{mathtools}
		  \\usepackage[superscript]{cite}
		  \\bibliographystyle{ieeetran}"
                  ("\\section{%s}" . "\\section*{%s}")
                  ("\\subsection{%s}" . "\\subsection*{%s}")
                  ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))

;                           --------------------

;  _             _               
; | |      __ _ | |_   ___ __  __
; | |     / _` || __| / _ \\ \/ /
; | |___ | (_| || |_ |  __/ >  < 
; |_____| \__,_| \__| \___|/_/\_\
;  ___        _  _    _        _  _            _    _            
; |_ _| _ _  (_)| |_ (_) __ _ | |(_) ___ __ _ | |_ (_) ___  _ _  
;  | | | ' \ | ||  _|| |/ _` || || |(_-</ _` ||  _|| |/ _ \| ' \ 
; |___||_||_||_| \__||_|\__,_||_||_|/__/\__,_| \__||_|\___/|_||_|

;; to have acces to PATH variable for latex
(require 'exec-path-from-shell) ;; if not using the ELPA package
(exec-path-from-shell-initialize)

(setq TeX-engine 'xetex)

;  ___             _  _  _             
; / __| _ __  ___ | || |(_) _ _   __ _ 
; \__ \| '_ \/ -_)| || || || ' \ / _` |
; |___/| .__/\___||_||_||_||_||_|\__, |
;      |_|                       |___/ 

;; flyspell
(dolist (hook '(latex-mode-hook))
  (add-hook hook (lambda () (interactive) (flyspell-mode 1) (ispell-change-dictionary "french") (flyspell-buffer))))
(eval-after-load "flyspell"
  '(progn
     (define-key flyspell-mouse-map [down-mouse-3] #'flyspell-correct-word)
     (define-key flyspell-mouse-map [mouse-3] #'undefined)
     (define-key flyspell-mouse-map [down-mouse-2] nil)
     (define-key flyspell-mouse-map [mouse-2] nil)))
(defun flyspell-buffer-after-pdict-save (&rest _)
  (flyspell-buffer))
;; (advice-add 'ispell-pdict-save :after #'flyspell-buffer-after-pdict-save)
(advice-add 'flyspell-mode-off :after #'flyspell-buffer-after-pdict-save)

;  ___                 _              
; | _ \ _ _  ___ __ __(_) ___ __ __ __
; |  _/| '_|/ -_)\ V /| |/ -_)\ V  V /
; |_|  |_|  \___| \_/ |_|\___| \_/\_/ 

;; doc-view
(require 'doc-view)
(setq doc-view-continuous t)
(setq doc-view-resolution 200)
;; (defadvice doc-view-display (after fit-width activate)
;;   (doc-view-fit-width-to-window))

;; latex preview
;; (latex-preview-pane-enable)

(add-hook 'doc-view-mode-hook (lambda () (global-set-key [mouse-7] 'image-forward-hscroll)))
(add-hook 'doc-view-mode-hook (lambda () (global-set-key [mouse-6] 'image-backward-hscroll)))

;; Okular and Latex
;; Don't forget to configure Okular to use emacs in "Configuration/Configure Okular/Editor" => Editor => Emacsclient. (you should see emacsclient -a emacs --no-wait +%l %f in the field "Command". Always ask for the master file when creating a new TeX file.
(setq-default TeX-master nil)
;; Enable synctex correlation. From Okular just press Shift + Left click to go to the good line.
(setq TeX-source-correlate-mode t
      TeX-source-correlate-start-server t)
;; Set Okular as the default PDF viewer.
(eval-after-load "tex"
  '(setcar (cdr (assoc 'output-pdf TeX-view-program-selection)) "Okular"))

;  ___        __                               
; | _ \ ___  / _| ___  _ _  ___  _ _   __  ___ 
; |   // -_)|  _|/ -_)| '_|/ -_)| ' \ / _|/ -_)
; |_|_\\___||_|  \___||_|  \___||_||_|\__|\___|

;; reftex
(require 'reftex)
(add-hook 'LaTeX-mode-hook 'TeX-PDF-mode) ;turn on pdf-mode.  AUCTeX
                                          ;will call pdflatex to
                                          ;compile instead of latex.
(add-hook 'LaTeX-mode-hook 'reftex-mode) ;turn on REFTeX mode by
                                         ;default
(setq reftex-plug-into-AUCTeX t)

(defun reftex-all ()
  (interactive)
  ;; (reftex-citation ".<RET>")
  (with-simulated-input '("hello SPC" (insert "world") "RET")
			(read-string "Enter greeting: "))
)

(define-key global-map (kbd "C-b") #'reftex-all)

;                           --------------------

;  _____           
; | ____| ___  ___ 
; |  _|  / __|/ __|
; | |___ \__ \\__ \
; |_____||___/|___/
;  ___     _  _  _    _             
; | __| __| |(_)| |_ (_) _ _   __ _ 
; | _| / _` || ||  _|| || ' \ / _` |
; |___|\__,_||_| \__||_||_||_|\__, |
;                             |___/ 

(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))


;; inferior-ess-r-mode
(defun init-R ()
  (interactive)
  ;; (setq default-frame-alist '((left . 0) (width . 155) (top . 0) (height . 42)))
  ;; (setq split-width-threshold 1)
  ;; (transpose-frame)
  ;; (set-buffer "*.R")


  (split-window-right)
  ;; (other-window 1)
  ;; (split-window-below)
  ;; (command-execute 'shell) 
 
)
(add-hook 'ess-r-mode-hook (lambda () (setq default-frame-alist '((left . 0) (width . 165) (top . 0) (height . 42)))))
(add-hook 'inferior-ess-r-mode-hook 'init-R)

;; (add-hook 'ess-r-mode-hook 'init-R)


;; stop asking 'active process exist'
(require 'cl-lib)
(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  "Prevent annoying \"Active processes exist\" query when you quit Emacs."
  (cl-letf (((symbol-function #'process-list) (lambda ())))
    ad-do-it))


;; (add-hook 'ess-r-mode-hook #'aggressive-indent-mode)
(fset 'rTAB
      "    ")
(add-hook 'ess-r-mode-hook (lambda () (global-set-key (kbd "<C-tab>")  'rTAB)))




;; (put 'dired-find-alternate-file 'disabled nil)
