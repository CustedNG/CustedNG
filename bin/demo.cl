(require core/scheme)

(setq data 
    (json-parse
        (http-body
            (http-get "https://ip.cn" '(user-agent curl/1)))))

(setq msg
    (string-join `(,(hash-ref data "country") " "
                   ,(hash-ref data "city") "@"
                   ,(hash-ref data "ip"))))
    
(custed-notify msg)
