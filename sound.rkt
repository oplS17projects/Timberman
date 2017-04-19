#lang racket
;; export
(provide (all-defined-out))

(require racket/gui/base)


(define (sound-chopping) (play-sound "assets/sounds/Chopping-edit.wav" #t))
(define (sound-gameover) (play-sound "assets/sounds/Game-over-edit.wav" #t))

(define (sound-menu) (play-sound "assets/sounds/menu-edit.wav" #t))
(define (sound-ingame) (play-sound "assets/sounds/ingame-edit.wav" #t))

;;(define music
;;  (list
;;   (list 'menu (rs-read "menu.wav"))
;;   (list 'ingame (rs-read "ingame.wav"))))
 
;;(define (play-forever sound)
  ;;(make-pstream [#:buffer-time buffer-time]) → pstream? Create a new pstream and start playing it.
  ;;(define play (make-pstream))
  ;;(rs-frames sound) → nonnegative-integer? Returns the length of a sound, in frames.
  ;;(define length (rs-frames sound))
  ;;(let looping ((time 1))
    ;;(pstream-queue pstream rsound frames) → pstream? Queue the given sound to be played at the time specified by frames.
    ;;(pstream-queue play sound (+ time 44100))
    ;;(define next (+ time length))
    ;;(looping next)))

;;(play-forever play) 

;; to play music
;;(pstream-queue (make-pstream) <name> 44100)
