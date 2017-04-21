#lang racket

(provide (all-defined-out))
(require "world-state.rkt" "gui.rkt" "variable.rkt" "database.rkt")
(require 2htdp/image 2htdp/universe)

;; Key event

; handle-key-event take state and key
(define (key-event state key)
  ; each state has its own key handler
  (cond
    [(game-start? state) (key/game-start state key)]
    [(playing?   state) (key/playing   state key)]
    [(game-over? state) (key/game-over state key)]
    [(highscore? state) (key/highscore state key)]
    (else state)))

(define (key/game-start state key)
  ; when the game in game-start mode
  ; the game will start with any key
  init-playing)

(define (key/playing state key)
  (cond
    ((key=? key "left")
     (update-playing-position character-pos-left state))
    ((key=? key "right")
     (update-playing-position character-pos-right state))
    ;;((key=? key "up") (update-playing-tree (playing-tree state) state))
    (else (update-playing-position (playing-position state) state))))
                     
(define (key/game-over state key)
  (cond ([key=? key " "] init-playing)
        ([key=? key "h"] (highscore (game-over-score state)))
        (else
         (game-over (game-over-score state) (game-over-position state) (game-over-tree state) 0))))

(define (key/highscore state key)
  (cond ([key=? key " "] init-playing)
        (else
         (highscore (highscore-current-score state)))))

; mouse event
(define (mouse-event state x y mouse)
  (cond ([game-over? state]  (mouse-event/game-over state x y mouse))
        ;;([highscore? state] (mouse-event/highscore state x y mouse))
        (else
         state)))

(define (mouse-event/game-over state x y mouse)
  (cond
    ((and (mouse=? mouse "button-down")
          (< (* (- (* 1/4 WIDTH) play-again-height) SCALE) x) (< (* (- (* 3/4 HEIGHT) play-again-height) SCALE) y)
          (> (* (+ (* 1/4 WIDTH) play-again-height) SCALE) x) (> (* (+ (* 3/4 HEIGHT) play-again-height) SCALE) y))
     (begin (update-table username (game-over-score state))
            init-playing))
    ((and (mouse=? mouse "button-down")
          (< (* (- (* 3/4 WIDTH) play-again-height) SCALE) x) (< (* (- (* 3/4 HEIGHT) play-again-height) SCALE) y)
          (> (* (+ (* 3/4 WIDTH) play-again-height) SCALE) x) (> (* (+ (* 3/4 HEIGHT) play-again-height) SCALE) y))
     (begin (update-table username (game-over-score state))
                          (highscore (game-over-score state))))
    (else (game-over (game-over-score state) (game-over-position state) (game-over-tree state) 0))))
    ;;(else (init-playing))))


;; Tick events

; tick-event
(define (tick-event state)
  (cond
    ((playing? state) (tick-event/playing state))
    ((chopping? state) (tick-event/chopping state))
    (else state)))

(define (tick-event/playing state)
  ;;(update-playing-time (playing-time state) state))
  (update-game state))

(define (tick-event/chopping state)
  (back-to-playing state))
