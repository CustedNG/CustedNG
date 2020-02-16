(require core/scheme)
(require ui)

(setq page1
  (center
    (column #:align 'center
      (list
        (h4 "Welcome")
        (button "Click Me"
          (lambda () (cave-put content page2)))))))

(setq page2
  (center
    (column #:align 'center
      (list
        (h4 "Page2")
        (button "< Back"
          (lambda () (cave-put content page1)))))))
 
(setq content (cave page1))

(view (page "Cave Example" content))

