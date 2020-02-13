(require core/scheme)

;; (setq body 
;;       (http-body (http-get "https://qq.com" '(content-type application/json))))

;; (prin1 (length body))

(setq ht (hash 'a 1 'b 2))
(prin1 `(,(hash-ref ht 'a)
         ,(hash-ref ht 'b)))

(prin1 (hash-set ht 'a 3))
(prin1 ht)

(prin1 (hash-set! ht 'a 3))
(prin1 ht)

(prin1 #t)