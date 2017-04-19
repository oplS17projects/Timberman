#lang racket

(require "gui.rkt" "world-state.rkt" "event-handler.rkt" "variable.rkt")
(require 2htdp/image 2htdp/universe)

;; Game big-bang

(big-bang (make-game-start)
          [on-draw draw]
          [on-key key-event]
          [on-tick tick-event]
          [on-mouse mouse-event]
          [name "Timber Man"])