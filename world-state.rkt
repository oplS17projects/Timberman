#lang racket

(provide (all-defined-out))
(require "sound.rkt")

;; Creating States

(define-struct game-start () #:transparent)
(define-struct playing (time score position tree) #:transparent)
(define-struct game-over (score position tree sound) #:transparent)
;; (define-struct highscore () #:transparent)

;; when timber man is at the left 1/6 and right 5/6
;;start time is 100
(define init-playing (make-playing 50 0 1/6 '(0 1 2 3 0 4)))


;;Manipulate data
(define time-decay 1)

(define (update-playing-time time state)
  (make-playing (- time (+ time-decay (/ (playing-score state) 50))) (playing-score state) (playing-position state) (playing-tree state)))

(define (update-playing-position position state)
  (define (add-time time)
    (if (> (+ time 5) 100)
        100
        (+ time 5)))
  (if (character-die position state)
      (make-game-over (playing-score state) position (playing-tree state) (sound-gameover))
      (begin (sound-chopping)
        (make-playing (add-time (playing-time state))
                    (+ (playing-score state) 1)
                    position
                    (enqueue (playing-tree state))))))

;; if character die, game over. Else update score, bonus time, enqueue tree
(define (update-game state)
  (if (character-die (playing-position state) state)
      (make-game-over (playing-score state) (playing-position state) (playing-tree state) (sound-gameover))
      (make-playing (- (playing-time state) 1)
                    (playing-score state)
                    (playing-position state)
                    (playing-tree state))))



;; Take a list, push the first number out then add 1 number to the end
;; the logic is the tree can't have the same side twice. Like 4 5 or 5 4
(define (enqueue lst)
  ((lambda (x)
     ;; get the last element of the list
     (cond ((and (= 3 (caddr (cdddr lst))) (= 4 x)) (enqueue lst))
           ((and (= 4 (caddr (cdddr lst))) (= 3 x)) (enqueue lst))
           ;; make sure the isn't more than 2 of the same trunk generate
           ((and (> 3 (cadr (cdddr lst))) (> 3 (caddr (cdddr lst))) (> 3 x)) (enqueue lst))
           ((= x (cadr (cdddr lst)) (caddr (cdddr lst))) (enqueue lst))
           (else (append (remove (car lst) lst) (cons x '())))))
   (random 5)))

         
;; Game logic where character die return true
(define (character-die position state)
  (cond ((and (= (car (playing-tree state)) 4)
              (= position 1/6)) #t)
        ((and (= (car (playing-tree state)) 3)
              (= position 5/6)) #t)
        ((= (playing-time state) 0) #t)
        (else #f)))