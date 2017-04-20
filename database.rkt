#lang racket

(provide (all-defined-out))
(require db)

(define data
  (postgresql-connect
   #:user "cjtvjnbaczmcyu"
   #:database "d1hioc7tekfh41"
   #:server "ec2-23-23-223-2.compute-1.amazonaws.com"
   #:ssl 'yes
   #:password "858a41f4062992060150c844020f8f0b4d98f8bf8c54405896d7fbef858b6f0f"))

;; if table already exist update the table, else create the table
(when (not (table-exists? data "hs"))
  (query-exec data "create table hs(name text primary key, score integer)"))

(define (update-table name score)
  (when (equal? name "") (set! name "NO NAME"))
  ;; only update when the score get higher
  ;; if name doesn't exist it return false else will also return score
  (define old-score
    (query-maybe-value data (~a "select score from hs where name = '" name "'")))
  (cond ((false? old-score) (query-exec data (~a "insert into hs values('" name "', " score ")")))
        ((> score old-score) (query-exec data (~a "update hs set score = " score "where name = '" name "'")))))

;; display score from highest to lowest
(define (display-score)
  (for ([(name score) (in-query data "select * from hs order by score desc")]) (printf "~a\t: ~a\n" name score)))

;; return list format ((name score) ....)
;; user asending order so recursive print out would reverse this
(define (get-database-list)
  (map (lambda (x y) (list x y))
   (query-list data "select name from hs order by score asc")
   (query-list data "select score from hs order by score asc")))



