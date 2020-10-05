(require core/scheme)
(require ui)

(defun title (txt) (text txt #:weight 'bold))

(setq my-page
  (page "Q&A"
    (listview
      (padding #:all 20
        (column
          (list
            (title "课表&成绩信息仅供参考")
            (sizedbox #:height 5)
            (title "请与教务系统中信息核对后使用!")
            (sizedbox #:height 20)
            (text "- Q: 课表缺课")
            (sizedbox #:height 5)
            (text "- A: CustedNG课表与教务课表保持同步, 请尝试查看教务课表是否缺课")
            (sizedbox #:height 20)
            (text "- Q: 如何将课程加入系统日历")
            (sizedbox #:height 5)
            (text "- A: 在课表中长按课程即可")
            (sizedbox #:height 20)
            (text "- Q: 如何连续翻页")
            (sizedbox #:height 5)
            (text "- A: 长按课表左/右翻页箭头即可")
            (sizedbox #:height 20)
            (text "- Q: 如何快速回到当前周")
            (sizedbox #:height 5)
            (text "- A: 长按课表中”第x周“即可")))))))

(view my-page)
