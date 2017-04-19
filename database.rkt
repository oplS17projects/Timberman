#lang racket

(provide (all-defined-out))

(require db)

(define data (sqlite3-connect #:database "hs.db"
                           #:mode 'create))

;; if table already exist update the table, else create the table
(when (not (table-exists? data "hs"))
  (query-exec data "create table hs(name text primary key, score integer)"))

(define (update-table name score)
  ;;(query-exec data "insert or replace into hs values('k', 300)"))
  ;; only update if score get higher
  (when (equal? name "") (set! name "NO NAME"))
  (define old-score
    (query-maybe-value data (~a "select score from hs where name = '" name "'")))
  (cond ((false? old-score) (query-exec data (concat-string name score)))
        ((> score old-score) (query-exec data (concat-string name score)))))

;; display score from highest to lowest
(define (display-score)
  (for ([(name score) (in-query data "select * from hs order by score desc")]) (printf "~a\t: ~a\n" name score)))

(define (concat-string name score)
    (~a "insert or replace into hs values('" name "', " score ")"))

;; return list format ((name score) ....)
;; user asending order so recursive print out would reverse this
(define (get-database-list)
  (map (lambda (x y) (list x y))
   (query-list data "select name from hs order by score asc")
   (query-list data "select score from hs order by score asc")))
