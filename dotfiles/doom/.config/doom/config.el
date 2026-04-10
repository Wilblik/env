;; Load PATH
(when (daemonp)
  (exec-path-from-shell-initialize))

;; Tell emacs that I have other files in config too
(add-to-list 'load-path "~/.config/doom/functions/")

;; Remove retarded hook that prevents me from replacing characters with <s> key
(remove-hook 'doom-first-input-hook #'evil-snipe-mode)

;; Directory where projects are located
(setq projectile-project-search-path '("~/Projects/"))

;; Minimap
(setq minimap-window-location 'right)
(map! :leader
      (:prefix ("o" . "open")
       :desc "Open minimap" "m" #'minimap-mode))

;; Org mode settings
(after! org
  (setq org-startup-folded t)
  (setq org-directory "~/Documents/Org/")
)

;; Moving buffers
(require 'buffer-move)
(global-set-key (kbd "<C-S-k>") 'buf-move-up)
(global-set-key (kbd "<C-S-j>") 'buf-move-down)
(global-set-key (kbd "<C-S-h>") 'buf-move-left)
(global-set-key (kbd "<C-S-l>") 'buf-move-right)

;; Dired settings
(setq dired-recursive-deletes 'always)
(setq dired-recursive-copies 'always)

;; Doom stuff
(setq user-full-name "Wilblik"
      user-mail-address "48726405+Wilblik@users.noreply.github.com")
(setq doom-theme 'doom-one)
(setq display-line-numbers-type 'relative)
