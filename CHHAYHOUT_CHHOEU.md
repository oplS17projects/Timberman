# Timber Man game in Racket

## Chhayhout Chhoeu
### April 30, 2017

# Overview
This is a game that was written in Racket. This game similiar to mobile game. It response to the keybord left and right. The most important feature is store high score on online database.

The code would recursively retrieve database from and print out the top score. If there is more than 10 people, it will print only 10.

The game client is inside ```Timberman.rkt``` file. Just open it with racket and then run it. It will prompt for the name. The game support keyboard and mouse input.

KEYS:
```left``` move or stay left
```right``` move or stay right
```space``` start the game

MOUSE:
On game over screen you will be able to click on the Replay and High Score button.

# Libraries Used
The code uses four libraries:

```racket
(require gui/base)
(require db)
(require 2htdp/images)
(require 2htdp/universe)
```

* For this specific project, ```gui/base``` library provide sound. We did not use rsound because it seem to be slow down the game.
* The ```db``` library is used to connect to online high score [heroku](https://rocky-meadow-57997.herokuapp.com/).
* The ```2htdp/images``` library is draw and place images.
* The ```2htdp/universe``` library is used to create windows and accepting input like keyboard and mouse click.

# Key Code Excerpts

## 1. Tail recursion

```racket
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
```
The function ```(draw-tree-trunk)``` will take a list of images and draw it accordingly to the height and weight as the place image on top of the tree truck. By having the tree truck as the base. Draw-iter is the tail recusion of draw tree trunk by retrieving the list of the 1st image and placing the image on top of it. 

## 2. Object Oriented programming

```racket
;; Creating States
(define-struct game-start () #:transparent)
(define-struct playing (time score position tree) #:transparent)
(define-struct game-over (score position tree sound) #:transparent)
(define-struct highscore (current-score) #:transparent)
```

World state for starting the program.

```racket
; mouse event
(define (mouse-event state x y mouse)
  (cond ([game-over? state]  (mouse-event/game-over state x y mouse))
        ;;([highscore? state] (mouse-event/highscore state x y mouse))
        (else
         state)))

(define (mouse-event/game-over state x y mouse)
  (cond
    ((and (mouse=? mouse "button-down")
          ;; play again
          (< (* (- (* 1/4 WIDTH) play-again-width) SCALE) x) (< (* (- (* 3/4 HEIGHT) play-again-height) SCALE) y)
          (> (* (+ (* 1/4 WIDTH) play-again-width) SCALE) x) (> (* (+ (* 3/4 HEIGHT) play-again-height) SCALE) y))
     init-playing)
    ((and (mouse=? mouse "button-down")
          (< (* (- (* 3/4 WIDTH) highscore-width) SCALE) x) (< (* (- (* 3/4 HEIGHT) highscore-height) SCALE) y)
          (> (* (+ (* 3/4 WIDTH) highscore-width) SCALE) x) (> (* (+ (* 3/4 HEIGHT) highscore-height) SCALE) y))
     (highscore (game-over-score state)))
    (else (game-over (game-over-score state) (game-over-position state) (game-over-tree state) 0))))
    ;;(else (init-playing))))
```

The universe.rkt teachpack implements and provides the functionality for creating interactive graphical programs. By using MouseEvents, via strings: "button-down" signals that the computer user has pushed a mouse button down. As the game reaches the game-over state, users will be about to click on two button which look like this, ![Alt text](assets/images/highscoreButton.png) and ![Alt text](assets/images/restartButton.png.png). Those two functions will allow the user to view the highscore or restart the game to a different state and initial a new game state.

## 3. External Technologies - Generate or Process sound

```racket
(define (sound-chopping) (play-sound "assets/sounds/Chopping-edit.wav" #t))
(define (sound-gameover) (play-sound "assets/sounds/Game-over-edit.wav" #t))

(define (sound-menu) (play-sound "assets/sounds/menu-edit.wav" #t))
(define (sound-ingame) (play-sound "assets/sounds/ingame-edit.wav" #t))

```
Defining the location for the sound files using gui/base.

```racket
  (if (character-die position state)
      (make-game-over (playing-score state) position (playing-tree state) (sound-gameover))        
            ...
               (enqueue (playing-tree state))
               (sound-chopping))))
```

I have used gui/base to add audio effect/effects unit and a music along when responsing to the user input. We cannot get rsound to works property because it effect the performance of the game. Which caused slow run times, that is why we switched to gui/base. By using gui/base library, it only took a couple of define statement and locations for the files. Which we used object oriented programming to define the ```(playing-tree state) ```. The function will be called by the position state when the avator swings his axe, it will play the sound of chopping along with the animation.

## 4. External Technologies - DATABASE

Database can be done offlice by using Sqlite3 and postgreSQL for online database storage.

```racket
(require db)
(define db (sqlite3-connect #:database "hs.db"
                           #:mode 'create))
                           
(define (update-table name score)
  ;; if table already exist update the table, else create the table
  (when (not (table-exists? db "hs"))
    (query-exec db "create table hs(name text primary key, score integer)"))
  ;;(query-exec db "insert or replace into hs values('k', 300)"))
  (query-exec db (concat-string name score)))

;; display score from highest to lowest
(define (display-score)
  (for ([(name score) (in-query db "select * from hs order by score desc")]) (printf "~a\t: ~a\n" name score)))

(define (concat-string name score)
    (~a "insert or replace into hs values('" name "', " score ")")) 
```

Before we use PostgreSQL, we were playing around with SQLite3. Althought we erased it, I just want to put it here. This function act as an offline/local storage for highscore. Which is the same as postgreSQL except it is offline. It will create a list of name and have a score correspondingly to the table. IT will score the highest value/score from highest to lowest. 

