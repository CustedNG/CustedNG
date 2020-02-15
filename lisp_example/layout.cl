(require core/scheme)
(require ui)

(setq my-page
  (page "Welcome"
    (column
      (list
        (text "你好\n欢迎使用CustedNG")))))

(view my-page)
