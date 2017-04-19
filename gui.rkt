#lang racket

(provide (all-defined-out))
(require 2htdp/image 2htdp/universe "world-state.rkt" "variable.rkt")



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
  (place-image play-again
               (* 1/4 WIDTH) (* 3/4 HEIGHT)
               (place-image text-game-over
                            (/ WIDTH 2) (* 1/4 HEIGHT)
                            (draw-timber-man-right (game-over-position state)
                                                   (place-image (text (number->string (game-over-score state)) 30 "red")
                                                                (/ WIDTH 2) (* 1/2 HEIGHT)
                                                                (draw-tree-trunk (game-over-tree state) (draw-ground)))))))
 

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
(define (draw-textbox image)
  (define username-text (text username 25 "red"))
  (place-image
   (overlay/align "left" "middle"
                  username-text
                  (rectangle (image-width username-text) 30 "outline" "red")
                  (rectangle (image-width username-text) 30 "solid" "white"))
   (/ WIDTH 2)
   15
   image))
