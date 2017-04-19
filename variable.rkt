#lang racket

(provide (all-defined-out))
(require 2htdp/image 2htdp/universe)

(define background (bitmap "assets/images/bg.png"))

(define timber-man-right (bitmap "assets/images/character-1.png"))

(define ground (bitmap "assets/images/stump.png"))

(define trunk
  (list (bitmap "assets/images/trunk-0.png")
        (bitmap "assets/images/trunk-1.png")
        (bitmap "assets/images/trunk-2.png")
        (bitmap "assets/images/trunk-3.png")
        (bitmap "assets/images/trunk-4.png")))

  
(define text-title (bitmap "assets/images/title.png"))

(define text-game-over (bitmap "assets/images/gameover.png"))

(define HEIGHT (image-height background))

(define WIDTH (image-width background))

(define play-again (bitmap "assets/images/restartButton.png"))

;; highscore button... need to replace it
(define highscore-button (bitmap "assets/images/restartButton.png"))

(define play-again-height (/ (image-height play-again) 2))

(define SCALE 1)

(define username "")