#lang racket

(require db)

(define db (sqlite3-connect #:database "hs.db"
                           #:mode 'create))


(define (update-table name score)
  ;; if table already exist update the table, else create the table
  (when (not (table-exists? db "hs"))
    (query-exec db "create table hs(name text primary key, score integer)"))
  ;;(query-exec db "insert or replace into hs values('k', 300)"))
  (query-exec db (concat-string name score)))

;; display score from highest to lowest
(define (display-score)
  (for ([(name score) (in-query db "select * from hs order by score desc")]) (printf "~a\t: ~a\n" name score)))

(define (concat-string name score)
    (~a "insert or replace into hs values('" name "', " score ")"))