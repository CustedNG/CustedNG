(require core/scheme)
(require ui)

(setq my-store (store-new))

(setq accu 1)

(setq my-page
  (page "Counter"
    (center
      (column
        `(,(store-listen my-store
             (lambda (msg) (text accu)))
          ,(button "Click Me"
             (lambda ()
               (setq accu (+ accu 1))
               (store-add my-store)))
          ,(button "Close"
             (lambda () (view-pop))))))))

(view my-page)
