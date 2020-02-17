(require core/scheme)
(require ui)

(defun title (txt) (text txt #:weight 'bold))

(defun link (url)
  (button url #:padding 0
    (lambda () (custed-launch-url url))))

(setq my-page
  (page ""
    (listview
      (padding #:all 20
        (column
          (list
            (title "常见问题汇总")
            (sizedbox #:height 20)
            (text "- 常见问题将在这里汇总")
            (sizedbox #:height 40)
            (title "加入用户组 获取最新资讯")
            (sizedbox #:height 20)
            (image "https://cust.xuty.cc/UserGroup.jpg" #:width 200)
            (sizedbox #:height 40)
            (title "源代码 & 反馈")
            ;; (sizedbox #:height 20)
            (link "https://github.com/CustedNG/CustedNG")))))))

(view my-page)
