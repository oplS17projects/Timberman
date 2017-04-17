#lang racket

(require rsound)

;;It currently has lots of restrictions (it insists on 16-bit PCM encoding, for instance).
(define play (rs-read "/Users/Chhayhout/Desktop/Chopping.wav"))
;(rs-read path) 
(define (sound)
  (list
   (list 'chopping (rs-read "/Users/Chhayhout/Desktop/Chopping.wav")
   (list 'gameover (rs-read "/Users/Chhayhout/Desktop/Game-over.wav")))))

(define (music)
  (list
   (list 'menu (rs-read "/Users/Chhayhout/Desktop/menu.wav"))
   (list 'ingame (rs-read "/Users/Chhayhout/Desktop/ingame.wav"))))
 
(define (play-forever sound)
  ;(make-pstream [#:buffer-time buffer-time]) → pstream? Create a new pstream and start playing it.
  (define play (make-pstream))
  ;(rs-frames sound) → nonnegative-integer? Returns the length of a sound, in frames.
  (define length (rs-frames sound))
  (let looping ((time 1))
    ;(pstream-queue pstream rsound frames) → pstream? Queue the given sound to be played at the time specified by frames.
    (pstream-queue play sound (+ time 44100))
    (define next (+ time length))
    (looping next)))

(play-forever play) 
