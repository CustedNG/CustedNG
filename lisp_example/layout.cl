(require core/scheme)
(require ui)

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
            (text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce non dictum elit, vitae mollis nisl. Donec et enim augue. Duis id ultrices velit. Phasellus a felis ipsum. Donec non nisl auctor, varius nulla elementum, gravida nibh. Nullam libero orci, ultrices non ornare et, semper a nunc. Praesent vitae egestas urna, sit amet porttitor velit. Phasellus vehicula ut sapien ac varius. Sed dapibus nibh sit amet odio blandit, sit amet elementum tellus euismod. Nulla mattis ex at nunc luctus congue.")))))))

(view my-page)
