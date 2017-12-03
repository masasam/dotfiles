(projectile-mode)
(counsel-projectile-on)


;; How to clear cache (M-x projectile-invalidate-cache)
(setq projectile-enable-caching t)


;; require ggtags
(setq projectile-tags-file-name "GTAGS")
(setq projectile-tags-command "gtags")
