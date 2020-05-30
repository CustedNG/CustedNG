(require core/scheme)
(require ui)

(setq content 
  (string-join
    "Lorem ipsum dolor sit amet,"
    "consectetur adipiscing elit. "
    "Fusce non dictum elit, vitae mollis nisl. "
    "Donec et enim augue. "
    "Duis id ultrices velit. "
    "Phasellus a felis ipsum. "
    "Donec non nisl auctor, varius nulla elementum, gravida nibh. "
    "Nullam libero orci, ultrices non ornare et, semper a nunc. "
    "Praesent vitae egestas urna, sit amet porttitor velit. "
    "Phasellus vehicula ut sapien ac varius. "
    "Sed dapibus nibh sit amet odio blandit, sit amet elementum tellus euismod. "
    "Nulla mattis ex at nunc luctus congue."))

(setq accu 1)
(setq counter-store (store-new))
(setq counter
  (row
    (list
      (store-listen counter-store
        (lambda (msg) 
          (text accu #:size 30 #:weight 'bold)))
      (button "Add"
        (lambda ()
          (setq accu (+ accu 1))
          (store-add counter-store))))))


(setq qr (image "https://cust.app/CustedNG.png"))

(defun link (url)
  (button url #:padding 0
    (lambda () (custed-launch-url url))))

(setq my-page
  (page "Welcome"
    (listview
      (padding #:all 20
        (column
          (list
            (h1 "Heading 1")
            (h2 "Heading 2")
            (h3 "Heading 3")
            (h4 "Heading 4")
            (h5 "Heading 5")
            (h6 "Heading 6")
            (sizedbox #:height 15)
            (text content)
            (sizedbox #:height 20)
            counter
            (link "https://cust.app/apk")
            qr))))))

(view my-page)