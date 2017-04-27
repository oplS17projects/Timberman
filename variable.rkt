#lang racket

(provide (all-defined-out))
(require 2htdp/image 2htdp/universe)

(define background (bitmap "assets/images/bg.png"))

(define timber-man-right (bitmap "assets/images/character-1.png"))
(define timber-man-left (bitmap "assets/images/character-2.png"))

(define timber-man-att-right (bitmap "assets/images/character-att-1.png"))
(define timber-man-att-left (bitmap "assets/images/character-att-2.png"))

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

(define character-pos-left 1/4)
(define character-pos-right 3/4)

;; highscore button... need to replace it
(define highscore-button (bitmap "assets/images/highscoreButton.png"))

(define highscore-height (/ (image-height highscore-button) 2))
(define highscore-width (/ (image-width highscore-button) 2))

(define play-again-height (/ (image-height play-again) 2))
(define play-again-width (/ (image-width play-again) 2))

(define right-branch 3)
(define left-branch 4)

(define SCALE 1)

(define dark-blue (make-color 68 132 166))

;;
(define username "")

(define (change-name name)
  (if (> (string-length name) 10)
      (set! username (substring name 0 9))
      (set! username name)))