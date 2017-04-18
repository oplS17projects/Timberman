#lang racket
;; export
(provide (all-defined-out))

(require rsound)

;;It currently has lots of restrictions (it insists on 16-bit PCM encoding, for instance).
(define sound-chopping (rs-read "assets/sounds/Chopping.wav"))
;(rs-read path)
(define sound-gameover (rs-read "assets/sounds/Game-over.wav"))

;;(define (sound)
;;  (list
;;   (list 'chopping (rs-read "Chopping.wav")
;;   (list 'gameover (rs-read "Game-over.wav")))))

(define sound-menu (rs-read "assets/sounds/menu.wav"))
(define sound-ingame (rs-read "assets/sounds/ingame.wav"))

;;(define music
;;  (list
;;   (list 'menu (rs-read "menu.wav"))
;;   (list 'ingame (rs-read "ingame.wav"))))
 
;;(define (play-forever sound)
  ;(make-pstream [#:buffer-time buffer-time]) → pstream? Create a new pstream and start playing it.
;;  (define play (make-pstream))
  ;(rs-frames sound) → nonnegative-integer? Returns the length of a sound, in frames.
;;  (define length (rs-frames sound))
;;  (let looping ((time 1))
    ;(pstream-queue pstream rsound frames) → pstream? Queue the given sound to be played at the time specified by frames.
;;    (pstream-queue play sound (+ time 44100))
;;    (define next (+ time length))
;;    (looping next)))

;;(play-forever play) 

;; to play music
;;(pstream-queue (make-pstream) <name> 44100)
