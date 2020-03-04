(require core/scheme)
(require ui)

(defun title (txt) (text txt #:weight 'bold))

(setq my-page
  (page ""
    (listview
      (padding #:all 20
        (column
          (list
            (title "课表&成绩信息仅供参考")
            (sizedbox #:height 5)
            (title "请与教务系统中信息核对后使用!")
            (sizedbox #:height 20)
            (text "- Q: 开学日期")
            (sizedbox #:height 5)
            (text "- A: 目前开学日期暂时显示为原定日期(2/24), 正确开学日期将在学校公布后更新")
            (sizedbox #:height 20)
            (text "- Q: 课表缺课")
            (sizedbox #:height 5)
            (text "- A: CustedNG课表与教务课表保持同步, 请尝试查看教务课表是否缺课")
            (sizedbox #:height 20)
            (text "- Q: 如何将课程加入系统日历")
            (sizedbox #:height 5)
            (text "- A: 在课表中长按课程即可")))))))

(view my-page)
