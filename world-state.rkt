#lang racket

(provide (all-defined-out))
(require "sound.rkt" "variable.rkt")

;; Creating States

(define-struct game-start () #:transparent)
(define-struct playing (time score position tree) #:transparent)
(define-struct game-over (score position tree sound) #:transparent)
(define-struct highscore (current-score) #:transparent)

;; for animation
(define-struct chopping (time score position tree sound) #:transparent)

;; when timber man is at the left 1/4 and right 3/4
;;start time is 50
(define init-playing (make-playing 50 0 character-pos-left '(0 1 2 3 0 4)))

;;Manipulate data
(define time-decay 1)

;;Time decay will get faster
(define (update-playing-time time state)
  (make-playing (- time (+ time-decay (/ (playing-score state) 20))) (playing-score state) (playing-position state) (playing-tree state)))

(define (update-playing-position position state)
  (define (add-time time)
    (if (> (+ time 4) 100)
        100
        (+ time 4)))
  (if (character-die position state)
      (make-game-over (playing-score state) position (playing-tree state) (sound-gameover))        
      (make-chopping (add-time (playing-time state))
                      (+ (playing-score state) 1)
                      position
                      (enqueue (playing-tree state))
                      (sound-chopping))))

;; if character die, game over. Else update score, bonus time, enqueue tree
(define (update-game state)
  (if (character-die (playing-position state) state)
      (make-game-over (playing-score state) (playing-position state) (playing-tree state) (sound-gameover))
      (make-playing (- (playing-time state) 1)
                    (playing-score state)
                    (playing-position state)
                    (playing-tree state))))


;; back to playing state
(define (back-to-playing state)
  (make-playing (chopping-time state)
                (chopping-score state)
                (chopping-position state)
                (chopping-tree state)))


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
              (= position character-pos-left)) #t)
        ((and (= (car (playing-tree state)) 3)
              (= position character-pos-right)) #t)
        ((= (playing-time state) 0) #t)
        (else #f)))
