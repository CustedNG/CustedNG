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
            (text "- Q: 传统登录提示输入手机号")
            (sizedbox #:height 5)
            (text "- A: 由于统一认证系统近期强制要求绑定手机号，使用统一认证登录然后绑定手机号即可继续使用传统登录")
            (sizedbox #:height 20)
            (text "- Q: 统一认证登录无法输入密码")
            (sizedbox #:height 5)
            (text "- A: 可能由于某些机型中的安全键盘导致，可以尝试临时关闭")
            (sizedbox #:height 40)
            (title "加入用户组 获取最新资讯")
            (sizedbox #:height 20)
            (image "https://cust.app/UserGroup.jpg" #:width 200)
            (sizedbox #:height 40)
            (title "源代码 & 反馈")
            (link "https://github.com/CustedNG/CustedNG")
            (sizedbox #:height 25)
            (title "手动下载最新版本")
            (sizedbox #:height 10)
            (button "立即下载(For Android)"  #:padding 0
              (lambda ()
                (custed-launch-url
                  "https://cust.app/apk")))
            (button "立即下载(For iOS)"  #:padding 0
              (lambda ()
                (custed-launch-url
                  "https://cust.app/ios")))))))))

(view my-page)
