(require core/scheme)
(require ui)

(setq my-page
  (page "LispView1"
    (center
      (column
        `(,(text "你好")
          ,(button "Close"
             (lambda () (view-pop))))))))

(view my-page)
