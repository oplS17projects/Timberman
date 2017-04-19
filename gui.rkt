#lang racket

(provide (all-defined-out))
(require 2htdp/image 2htdp/universe "world-state.rkt" "variable.rkt"  "database.rkt")

;;convert lst of number to lst of trunk
(define (lst-to-trunk lst)
  (if (null? lst)
      '()
      (cons (list-ref trunk (car lst)) (lst-to-trunk (cdr lst)))))

;; Drawing States
; draw take state and return image
(define (draw state)
  (cond
    [(game-start? state) (scale SCALE (draw-game-start state))]
    [(playing? state) (scale SCALE (draw-playing state))]
    [(game-over? state) (scale SCALE (draw-game-over state))]
    [(highscore? state) (scale SCALE (draw-highscore state))]
    [else (error 'unknown)]))

;; The game start state with twice of scale of original image
(define (draw-game-start state)
  (place-image text-title
               (/ WIDTH 2) (* 1/4 HEIGHT)
               background))

(define (draw-playing state)
  (define time (playing-time state))
  (define score (playing-score state))
  (define position (playing-position state))
  (define tree (playing-tree state))
  (draw-playing-state time score position tree))


(define (draw-playing-state time score position tree)
  (draw-timber-man-right position
                         (draw-score score
                                     (draw-time-bar time
                                                    (draw-tree-trunk tree (draw-ground))))))


(define (draw-game-over state)
  (draw-two-button
   (draw-textbox
   (place-image text-game-over
                (/ WIDTH 2) (* 1/4 HEIGHT)
                (draw-timber-man-right (game-over-position state)
                                       (place-image (text (number->string (game-over-score state)) 30 "red")
                                                    (/ WIDTH 2) (* 1/2 HEIGHT)
                                                    (draw-tree-trunk (game-over-tree state) (draw-ground))))))))
 

;;draw the top high score
(define (draw-highscore state)
  (define (draw-current-score score image)
    (place-image (text (~a "Your score: " score) 60 "Blue")
                 (/ WIDTH 2)
                 60
                 image))
  (define (draw-iter lst n image)
    (if (> n 0)
        (place-image (text (caar lst) 50 "red")
                     (+ (/ (image-width (text (caar lst) 50 "red")) 2) 25)
                     (- HEIGHT (* n 60))
                     (place-image (text (number->string (cadar lst)) 50 "red")
                                  (- WIDTH (/ (image-width (text (number->string (cadar lst)) 25 "red")) 2) 25)
                                  (- HEIGHT (* n 60))
                                  (draw-iter (cdr lst) (- n 1) image)))
        image))
  (define a (get-database-list))
  (define b (draw-current-score (number->string (highscore-current-score state)) background))
  (if (> (length a) 10)
      (draw-iter a 10 b)
      (draw-iter a (length a) b)))

  

;;draw ground
(define (draw-ground)
  (place-image ground
               (/ WIDTH 2)
               HEIGHT
               background))

;;draw timber man
(define (draw-timber-man-right position image)
  (place-image timber-man-right
               ;; because the ratio of the background is 2:3
               (* position WIDTH)
               (- HEIGHT (image-height ground))
               image))

;;draw tree trunk
(define (draw-tree-trunk lst image)
  (define (draw-iter lst height image)
    (if (null? lst)
        image
        (place-image (car lst)
                     (/ WIDTH 2)
                     (- HEIGHT height)
                     (draw-iter (cdr lst)
                                (+ height (- (image-height (car lst)) 1)) image))))
  (draw-iter (lst-to-trunk lst) (- (image-height ground) 1) image))

;;draw score
(define (draw-score score image)
  (place-image (text (number->string score) 30 "red")
               (- WIDTH 30)
               30
               image))

;;draw time bar
(define (draw-time-bar time image)
  (place-image
   (overlay/align "left" "middle"
                 (rectangle 100 20 "outline" "red")
                 (rectangle time 20 "solid" "red"))
   (/ WIDTH 2)
   (* 1/4 HEIGHT)
   image))

;;draw username textbox and letter inside
(define (draw-textbox image name)
  (define username-text (text name 25 "red"))
  (place-image
   (overlay/align "left" "middle"
                  username-text
                  (rectangle (image-width username-text) 30 "outline" "red")
                  (rectangle (image-width username-text) 30 "solid" "white"))
   (/ WIDTH 2)
   15
   image))

;;draw 2 button. Restart and highscore
(define (draw-two-button image)
  (place-image highscore-button
               (* 3/4 WIDTH) (* 3/4 HEIGHT)
               (place-image play-again
                            (* 1/4 WIDTH) (* 3/4 HEIGHT)
                            image)))

