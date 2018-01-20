;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname rectangle) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #t)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Carolina Li (20725487)
;; CS135 Fall 2017
;; Assignment 09, Question 02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "rectanglelib.rkt")

(define-struct cell (num used?))
;; A Cell is a (make-cell Nat Bool)

;; A Grid is a (listof (listof Cell))
;; requires: the grid contains a non-empty list of non-empty lists,
;;  all the same length.

(define-struct rect (x y w h))
;; A Rect is a (make-rect Nat Nat Nat Nat)

(define-struct state (grid rects))
;; A State is a (make-state Grid (listof Rect))


;; Here are a couple of constants that can be used to define
;; the puzzle in the assignment, and a random larger puzzle.

(define puzz '((0 0 0 0 0 5 0)
               (0 0 0 0 0 2 2)
               (0 3 0 6 3 2 0)
               (4 0 0 0 0 0 0)
               (0 0 0 4 0 4 0)
               (2 0 6 0 2 4 0)
               (0 0 0 0 0 0 0)))

(define big-puzz '((4 0 7 0 0 0 0 0 0 0 0 21 0)
                   (0 3 2 0 0 0 0 0 0 0 0 0 2)
                   (0 0 0 0 0 0 0 2 3 0 0 0 0)
                   (0 0 0 20 0 0 0 0 0 0 0 0 5)
                   (0 2 0 0 0 0 0 4 0 0 0 0 0)
                   (0 0 3 0 0 0 0 0 0 0 0 0 0)
                   (3 0 0 0 0 5 2 4 0 0 0 0 0)
                   (0 0 0 0 0 2 0 6 0 0 0 0 0)
                   (0 0 0 20 0 0 0 0 0 0 0 0 0)
                   (0 0 0 0 0 0 0 0 0 0 0 0 0)
                   (0 0 0 0 0 0 0 0 0 0 0 24 0)
                   (0 0 0 0 4 0 4 0 0 0 4 0 0)
                   (0 0 3 0 0 0 0 0 0 0 8 0 2)))

;; useful constants for testing:

(define no-solution
  (make-state
   (list (list (make-cell 0 false) (make-cell 7 false))
         (list (make-cell 0 false) (make-cell 0 false))
         (list (make-cell 2 false) (make-cell 0 false)))
   empty))

(define small-state
  (make-state
   (list (list (make-cell 0 false) (make-cell 2 false))) empty))

(define final-small-state
  (make-state
   (list (list (make-cell 0 false) (make-cell 2 false)))
   (list (make-rect 0 0 2 1))))

(define small-grid
  (state-grid small-state))

(define small-state-neighbours
  (list
   (make-state
    (list (list (make-cell 0 true) (make-cell 2 true)))
    (list (make-rect 0 0 2 1)))))
  

(define initial-state-4-2
  (make-state
   (list (list (make-cell 0 false) (make-cell 4 false))
         (list (make-cell 0 false) (make-cell 0 false))
         (list (make-cell 2 false) (make-cell 0 false)))
   empty))

(define initial-state-4-2-neighbours
  (list
   (make-state (list (list (make-cell 0 true) (make-cell 4 true))
                     (list (make-cell 0 true) (make-cell 0 true))
                     (list (make-cell 2 false) (make-cell 0 false)))
               (list (make-rect 0 0 2 2)))))

(define initial-grid-4-2
  (list (list (make-cell 0 false) (make-cell 4 false))
        (list (make-cell 0 false) (make-cell 0 false))
        (list (make-cell 2 false) (make-cell 0 false))))
  

(define final-state-4-2
  (make-state
   (list (list (make-cell 0 true) (make-cell 4 true))
         (list (make-cell 0 true) (make-cell 0 true))
         (list (make-cell 2 true) (make-cell 0 true)))
   empty))

(define final-grid-4-2
  (list (list (make-cell 0 true) (make-cell 4 true))
        (list (make-cell 0 true) (make-cell 0 true))
        (list (make-cell 2 true) (make-cell 0 true))))

(define mid-state-4-2
  (make-state
   (list (list (make-cell 0 true) (make-cell 4 true))
         (list (make-cell 0 true) (make-cell 0 true))
         (list (make-cell 2 false) (make-cell 0 false)))
   empty))

(define mid-state-4-2-neighbours
  (list (make-state
         (list (list (make-cell 0 true) (make-cell 4 true))
               (list (make-cell 0 true) (make-cell 0 true))
               (list (make-cell 2 true) (make-cell 0 true)))
         (list (make-rect 0 2 2 1)))))

(define mid-grid-4-2
  (list (list (make-cell 0 true) (make-cell 4 true))
        (list (make-cell 0 true) (make-cell 0 true))
        (list (make-cell 2 false) (make-cell 0 false))))

(define initial-state-8-4
  (make-state
   (list (list (make-cell 0 false) (make-cell 0 false)
               (make-cell 8 false) (make-cell 0 false)
               (make-cell 0 false) (make-cell 4 false))
         (list (make-cell 0 false) (make-cell 0 false)
               (make-cell 0 false) (make-cell 0 false)
               (make-cell 0 false) (make-cell 0 false)))
   empty))

(define final-state-8-4
  (make-state
   (list (list (make-cell 0 true) (make-cell 0 true)
               (make-cell 8 true) (make-cell 0 true)
               (make-cell 0 true) (make-cell 4 true))
         (list (make-cell 0 true) (make-cell 0 true)
               (make-cell 0 true) (make-cell 0 true)
               (make-cell 0 true) (make-cell 0 true)))
   empty))

(define mid-grid-8-4
  (list (list (make-cell 0 true) (make-cell 0 true)
              (make-cell 8 true) (make-cell 0 true)
              (make-cell 0 true) (make-cell 4 true))
        (list (make-cell 0 true) (make-cell 0 true)
              (make-cell 0 true) (make-cell 0 false)
              (make-cell 0 true) (make-cell 0 true))))

(define other-mid-grid-8-4
  (list (list (make-cell 0 true) (make-cell 0 true)
              (make-cell 8 false) (make-cell 0 false)
              (make-cell 0 true) (make-cell 4 true))
        (list (make-cell 0 true) (make-cell 0 true)
              (make-cell 0 true) (make-cell 0 false)
              (make-cell 0 true) (make-cell 0 true))))

(define state-mult
  (make-state
   (list (list (make-cell 4 false) (make-cell 0 false)
               (make-cell 0 false) (make-cell 0 false))
         (list (make-cell 0 false) (make-cell 0 false)
               (make-cell 0 false) (make-cell 0 false))
         (list (make-cell 0 false) (make-cell 0 false)
               (make-cell 0 false) (make-cell 0 false))
         (list (make-cell 0 false) (make-cell 0 false)
               (make-cell 0 false) (make-cell 0 false)))
   empty))

(define state-mult-neighbours
  (list (make-state
         (list (list (make-cell 4 true) (make-cell 0 true)
                     (make-cell 0 true) (make-cell 0 true))
               (list (make-cell 0 false) (make-cell 0 false)
                     (make-cell 0 false) (make-cell 0 false))
               (list (make-cell 0 false) (make-cell 0 false)
                     (make-cell 0 false) (make-cell 0 false))
               (list (make-cell 0 false) (make-cell 0 false)
                     (make-cell 0 false) (make-cell 0 false)))
         (list (make-rect 0 0 4 1)))
        (make-state
         (list (list (make-cell 4 true) (make-cell 0 true)
                     (make-cell 0 false) (make-cell 0 false))
               (list (make-cell 0 true) (make-cell 0 true)
                     (make-cell 0 false) (make-cell 0 false))
               (list (make-cell 0 false) (make-cell 0 false)
                     (make-cell 0 false) (make-cell 0 false))
               (list (make-cell 0 false) (make-cell 0 false)
                     (make-cell 0 false) (make-cell 0 false)))
         (list (make-rect 0 0 2 2)))
        (make-state
         (list (list (make-cell 4 true) (make-cell 0 false)
                     (make-cell 0 false) (make-cell 0 false))
               (list (make-cell 0 true) (make-cell 0 false)
                     (make-cell 0 false) (make-cell 0 false))
               (list (make-cell 0 true) (make-cell 0 false)
                     (make-cell 0 false) (make-cell 0 false))
               (list (make-cell 0 true) (make-cell 0 false)
                     (make-cell 0 false) (make-cell 0 false)))
         (list (make-rect 0 0 1 4)))))
  

;; -----------------------------PART A--------------------------------

;; (map2d f lolists) maps f onto every element in lolists
;; map2d: (X -> Y) (listof (listof X)) -> (listof (listof Y))
;; examples:
(check-expect (map2d add1 empty) empty)
(check-expect (map2d add1 (list (list 1 2 3))) (list (list 2 3 4)))

(define (map2d f lolists)
  (map (lambda (x) (map f x)) lolists))

;; tests:
(check-expect (map2d add1 (list (list 1 2 3) (list 8 7 6)))
              (list (list 2 3 4) (list 9 8 7)))
(check-expect (map2d floor (list (list 1.1 2.3) (list 8.1 7.9 6.4)))
              (list (list 1 2) (list 8 7 6)))

;; -----------------------------PART B--------------------------------

;; (construct-puzzle num-table) builds a "puzzle" according to the
;;    info provided in lon; i.e. it represents the lon table as a Grid
;;    of Cells and an empty list of Rects
;; construct-puzzle: (listof (listof Num)) -> State
;; requires: all sublists have the same length
;; examples:
(check-expect (construct-puzzle empty) (make-state empty empty))
(check-expect (construct-puzzle (list (list 0 4) (list 0 0)))
              (make-state
               (list (list (make-cell 0 false) (make-cell 4 false))
                     (list (make-cell 0 false) (make-cell 0 false)))
               empty))

(define (construct-puzzle num-table)
  (make-state (map2d (lambda (x) (make-cell x false)) num-table)
              empty))

;; tests:
(check-expect (construct-puzzle
               (list (list 0 4) (list 0 0) (list 2 0)))
              initial-state-4-2)


;; -----------------------------PART C--------------------------------

;; (row-solved? row) checks if a single "row" of Cells is fully solved
;; row-solved?: (listof Cell) -> Bool
;; examples:
(check-expect (row-solved? (list (make-cell 0 false))) false)
(check-expect (row-solved? (list (make-cell 0 true))) true)

(define (row-solved? row)
  (cond
    [(empty? row) true]
    [(cell-used? (first row)) (row-solved? (rest row))]
    [else false]))


;; (grid-solved? g) checks if the Grid represented by g is
;;    fully-solved
;; grid-solved?: Grid -> Bool
;; examples:
(check-expect (grid-solved? (list (list (make-cell 0 false)))) false)
(check-expect (grid-solved? (list (list (make-cell 0 true)))) true)

(define (grid-solved? g)
  (cond
    [(empty? g) true]
    [(row-solved? (first g)) (grid-solved? (rest g))]
    [else (row-solved? (first g))]))
  


;; (solved? s) checks if the State described by s represents a
;;    fully-solved puzzle
;; solved?: State -> Bool
;; examples:
(check-expect (solved? initial-state-4-2) false)
(check-expect (solved? final-state-4-2) true)

(define (solved? s)
  (grid-solved? (state-grid s)))

;; tests:
(check-expect (solved? mid-state-4-2) false)
(check-expect (solved? initial-state-8-4) false)
(check-expect (solved? final-state-8-4) true)


;; -----------------------------PART D--------------------------------


;; (find-col-unused row acc) returns the position of the leftmost
;;    unused Cell in row
;; find-col-unused: (listof Cell) Nat -> Nat
;; examples:
(check-expect (find-col-unused
               (list (make-cell 0 false) (make-cell 4 false)) 0) 0)
(check-expect (find-col-unused
               (list (make-cell 0 true) (make-cell 4 false)) 0) 1)

(define (find-col-unused row acc)
  (cond
    [(empty? row) acc]
    [(not (cell-used? (first row))) acc]
    [else (find-col-unused (rest row) (add1 acc))]))



;; (get-row-unused grid index) returns the row in grid that's
;;    positioned at index
;; get-row-unused: Grid Nat -> (listof Cell)
;; examples:
(check-expect (get-row-unused initial-grid-4-2 0)
              (list (make-cell 0 false) (make-cell 4 false)))
(check-expect (get-row-unused mid-grid-4-2 2)
              (list (make-cell 2 false) (make-cell 0 false)))

(define (get-row-unused grid index)
  (cond
    [(empty? grid) empty]
    [(= index 0) (first grid)]
    [else (get-row-unused (rest grid) (sub1 index))]))


;; (find-row-unused grid acc) returns the index number of the topmost
;;    row in grid that contains an unused Cell, by storing it in acc
;; find-row-unused: Grid Nat -> Nat 
;; examples:
(check-expect (find-row-unused initial-grid-4-2 0) 0)
(check-expect (find-row-unused mid-grid-4-2 0) 2)

(define (find-row-unused grid acc)
  (cond
    [(empty? grid) acc]
    [(not (row-solved? (first grid))) acc]
    [else (find-row-unused (rest grid) (add1 acc))]))


;; (get-first-unused grid) produces the coordinates of the topmost,
;;    leftmost unused Cell in grid
;; get-first-unused: Grid -> (list Nat Nat)
;; examples:
(check-expect (get-first-unused initial-grid-4-2) (list 0 0))
(check-expect (get-first-unused mid-grid-4-2) (list 0 2))

(define (get-first-unused grid)
  (list (find-col-unused (get-row-unused grid
                                         (find-row-unused grid 0))0)
        (find-row-unused grid 0)))

;; tests:
(check-expect (get-first-unused mid-grid-8-4) (list 3 1))
(check-expect (get-first-unused other-mid-grid-8-4) (list 2 0))


;; -----------------------------PART E--------------------------------

;; (subrow row start end) returns the part of subrow from start and
;;    up to but not including end
;; subrow: (listof X) Nat Nat -> (listof X)
;; example:
(check-expect (subrow '(1 2 3 4) 1 2) '(2))

(define (subrow row start end)
  (cond
    [(empty? row) empty]
    [(= end 0) empty]
    [(= start 0)
     (cons (first row) (subrow (rest row) start (sub1 end)))]
    [else (subrow (rest row) (sub1 start) (sub1 end))]))


;; (crop-height grid y-start y-end) returns the part of grid that
;;    lies between y-start and y-end
;; crop-height: Grid Nat Nat -> Grid
;; requires: y-end > y-start
;; example:
(check-expect (crop-height small-grid 0 1) small-grid)

(define (crop-height grid y-start y-end)
  (cond
    [(empty? grid) empty]
    [(= y-end 0) empty]
    [(= y-start 0)
     (cons (first grid)
           (crop-height (rest grid) y-start (sub1 y-end)))]
    [else
     (crop-height (rest grid) (sub1 y-start) (sub1 y-end))]))


;; (grid-under-rect rect grid) produces only the part of
;;    grid that's "covered" by rect
;; grid-under-rect: Rect Grid -> Grid
;; examples:
(check-expect (grid-under-rect (make-rect 0 0 1 1) small-grid)
              (list (list (make-cell 0 false))))
(check-expect (grid-under-rect (make-rect 0 0 2 1) small-grid)
              small-grid)

(define (grid-under-rect rect grid)
  (local
    [(define cropped
       (crop-height grid (rect-y rect)
                    (+ (rect-y rect) (rect-h rect))))
     (define (crop-width rows)
       (cond
         [(empty? rows) empty]
         [else (cons (subrow (first rows) (rect-x rect)
                             (+ (rect-x rect) (rect-w rect)))
                     (crop-width (rest rows)))]))]
    (crop-width cropped)))

;; tests:
(check-expect (grid-under-rect (make-rect 1 0 1 1) small-grid)
              (list (list (make-cell 2 false))))
(check-expect (grid-under-rect (make-rect 1 0 1 1) initial-grid-4-2)
              (list (list (make-cell 4 false))))
(check-expect (grid-under-rect (make-rect 0 0 1 2) initial-grid-4-2)
              (list (list (make-cell 0 false))
                    (list (make-cell 0 false))))
(check-expect (grid-under-rect (make-rect 1 0 1 3) initial-grid-4-2)
              (list (list (make-cell 4 false))
                    (list (make-cell 0 false))
                    (list (make-cell 0 false))))
(check-expect (grid-under-rect (make-rect 0 1 2 2) initial-grid-4-2)
              (list (list (make-cell 0 false) (make-cell 0 false))
                    (list (make-cell 2 false) (make-cell 0 false))))



;; *******************************



;; (grid->list g) converts Grid g into a flat list containing all
;;    the Cells in g
;; grid->list: Grid -> (listof Cell)
;; examples:
(check-expect (grid->list small-grid)
              (list (make-cell 0 false) (make-cell 2 false)))

(define (grid->list g)
  (foldr (lambda (curr rst) (append curr rst)) empty g))

;; test:
(check-expect (grid->list initial-grid-4-2)
              (list (make-cell 0 false) (make-cell 4 false)
                    (make-cell 0 false) (make-cell 0 false)
                    (make-cell 2 false) (make-cell 0 false)))  



;; (all-unused? locells) tests if every Cell in locells is unused
;; all-unused?: (listof Cell) -> Bool
;; examples:
(check-expect (all-unused?
               (list (make-cell 0 false) (make-cell 4 false))) true)

(define (all-unused? locells)
  (empty? (filter cell-used? locells)))

;; tests:
(check-expect (all-unused?
               (list (make-cell 0 false) (make-cell 4 true))) false)
(check-expect (all-unused?
               (list (make-cell 0 true) (make-cell 4 false))) false)



;; (valid-rect? cells) tests if the rectangle represented by cells is
;;    valid
;; valid-rect?: (listof Cell) -> Bool
;; examples:
(check-expect (valid-rect? (grid->list small-grid)) true)
(check-expect (valid-rect? (grid->list initial-grid-4-2)) false)

(define (valid-rect? cells)
  (local
    [
     ;; (how-many-numbered locells) counts the number of Cells in
     ;;    locells that contains a number not equal to 0
     ;; how-many-numbered: (listof Cell) -> Nat

     (define (how-many-numbered locells)
       (length
        (filter (lambda (x) (not (= 0 (cell-num x)))) locells)))
     

     ;; (find-number locells) returns the Num value of the Cell in locells
     ;; find-number: (listof Cell) -> Nat
     ;; requires: there is exactly one Cell in locells that has a num
     ;;    not equal to 0

     (define (find-number locells)
       (foldl (lambda (curr sum) (+ (cell-num curr) sum)) 0 locells))

     
     ;; (num-matches? locells) tests if the Rect that's represented
     ;;    by locells has the same area as its Num value
     ;; num-matches?: (listof Cell) -> Bool

     (define (num-matches? locells)
       (cond
         [(= 1 (how-many-numbered locells))
          (= (find-number locells) (length locells))]
         [else false]))]
    
    (and (all-unused? cells) (num-matches? cells))))

;; tests:
(check-expect (valid-rect? (grid->list final-grid-4-2)) false)
(check-expect
 (valid-rect? (list (make-cell 1 false) (make-cell 1 false))) false)
(check-expect
 (valid-rect? (list (make-cell 0 false) (make-cell 7 false))) false)
(check-expect
 (valid-rect? (list (make-cell 0 false) (make-cell 2 true))) false)



;; **********************************



;; (neighbours s) produces a list containing all possible States
;;    that follow from State s after adding a single Rectangle at the
;;    topmost, leftmost Cell
;; neighbours: State -> (listof State)
;; examples:
(check-expect (neighbours final-state-4-2) empty)
(check-expect (neighbours small-state) small-state-neighbours)

(define (neighbours s)
  (local
    [
     ;; (all-rectangles g pos width) generates a list of all the
     ;;    Rects starting at pos that can fit horizontally in
     ;;    Grid g, with width as the max value
     ;; all-rectangles: Grid (list Nat Nat) Nat -> (listof Rect)

     (define (all-rectangles g pos width)
       (local
         [
          ;; (build-rect g pos width) creates a list of Rects that fit
          ;;    vertically in Grid g, starting at pos, all with
          ;;    x-value of width
          ;; build-rect: Grid (list Nat Nat) Nat -> (listof Rect)
          (define (build-rect g pos width)
            (build-list (- (length g) (second pos))
                        (lambda (x)
                          (make-rect (first pos) (second pos)
                                     width (add1 x)))))]
         (cond
           [(= width 0) empty]
           [else (append (build-rect g pos width)
                         (all-rectangles g pos (sub1 width)))])))
    
     (define general-rects 
       (all-rectangles (state-grid s)
                       (get-first-unused (state-grid s))
                       (- (length (first (state-grid s)))
                          (first (get-first-unused (state-grid s))))))
     
     ;; (update-state r s) marks all Cells in State s that are
     ;;    covered by Rect r as used, and adds r's Rect to s's
     ;;    list of Rects
     ;; update-state: (list Rect (listof Cell)) State -> State

     (define (update-state r s)
       (local
         [
          ;; (subrow-to-used row start end i) creates a new row where
          ;;    every Cell from start and up to but not including end
          ;;    is marked as "used", using i as an index
          ;; subrow-to-used: (listof Cell) Nat Nat Nat ->
          ;;                 (listof Cell)

          (define (subrow-to-used row start end i)
            (cond
              [(empty? row) empty]
              [(and (>= i start) (< i end))
               (cons (make-cell (cell-num (first row)) true)
                     (subrow-to-used (rest row) start end (add1 i)))]
              [else
               (cons (first row)
                     (subrow-to-used
                      (rest row) start end (add1 i)))]))

          ;; (to-used-heightwise grid start end i) creates a new Grid
          ;;    where every row of Cells between start and end in grid
          ;;    are accurately marked as used, using i as an index
          ;; to-used-heightwise: Grid Nat Nat Nat -> Grid
          ;; requires: end > start

          (define (to-used-heightwise grid start end i)
            (cond
              [(empty? grid) empty]
              [(and (>= i start) (< i end))
               (cons
                (subrow-to-used (first grid) (rect-x r)
                                (+ (rect-x r)(rect-w r)) 0)
                (to-used-heightwise (rest grid) start end (add1 i)))]
              [else
               (cons (first grid)
                     (to-used-heightwise
                      (rest grid) start end (add1 i)))]))

          ;; (add-rect r s) adds Rect r to the list of Rects from State s
          ;; add-rect: Rect State -> (listof Rect)

          (define (add-rect r s)
            (cons r (state-rects s)))]
    
         (make-state
          (to-used-heightwise (state-grid s) (rect-y r)
                              (+ (rect-y r) (rect-h r)) 0)
          (add-rect r s))))

     ;; (make-states lorects s) produces a list of States, with each
     ;;    State altered from State s by each Rect in lorects
     ;; make-states: (listof Rect) State -> (listof State)

     (define (make-states lorects s)
       (cond
         [(empty? lorects) empty]
         [else (cons (update-state (first lorects) s)
                     (make-states (rest lorects) s))]))


     ;; (make-pair r s) produces a "pair"; i.e. a list with Rect r as the
     ;;    1st element and it's corresponding Cells in State s as the
     ;;    2nd element
     ;; make-pair: Rect State -> (list Rect (listof Cell))

     (define (make-pair r s)
       (cons r (list (grid->list (grid-under-rect r (state-grid s))))))



     ;; (make-association-lst lorects s) produces an association
     ;;    list from lorects with the Rect info as the key and the
     ;;    Cell info (taken from State s) as the value
     ;; make-association-lst: (listof Rect) State ->
     ;;                       (listof (list Rect (listof Cell)))

     (define (make-association-lst lorects s)
       (cond
         [(empty? lorects) empty]
         [else (cons (make-pair (first lorects) s)
                     (make-association-lst (rest lorects) s))]))


     ;; (validate-association-lst alst) creates a new association list
     ;;    containing only the Rects that are valid
     ;; (validate-association-lst:
     ;;    (listof (list Rect (listof Cell))) ->
     ;;    (listof (list Rect (listof Cell)))

     (define (validate-association-lst alst)
       (foldr (lambda (curr rst)
                (cond
                  [(valid-rect? (second curr)) (cons curr rst)]
                  [else rst]))
              empty
              alst))


     ;; (validate-lorects lorects s) produces a list of only the valid
     ;;    Rects in State s
     ;; validate-lorects: (listof Rects) State -> (listof Rects)

     (define (validate-lorects lorects s)
       (local
         [(define validated-alst
            (validate-association-lst
             (make-association-lst lorects s)))]
         (foldr (lambda (curr rst) (cons (first curr) rst))
                empty
                validated-alst)))

     ]
    
    (cond
      [(solved? s) empty]
      [else (make-states (validate-lorects general-rects s) s)])))

;; tests:
(check-expect (neighbours no-solution) empty)
(check-expect (neighbours initial-state-4-2)
              initial-state-4-2-neighbours)
(check-expect (neighbours mid-state-4-2) mid-state-4-2-neighbours)
(check-expect
 (lists-equiv? (neighbours state-mult) state-mult-neighbours) true)



;; -----------------------------PART F--------------------------------

;; (solve-rectangle-puzzle init-puzzle) produces the list of Rects
;;    that solve init-puzzle, or false if init-puzzle is unsolvable
;; solve-rectangle-puzzle: (listof (listof Nat)) ->
;;                         (anyof (listof Rect) false)
;; examples:
(check-expect (solve-rectangle-puzzle (list (list 0 2)))
              (list (make-rect 0 0 2 1)))
(check-expect (solve-rectangle-puzzle (list (list 0 3))) false)

(define (solve-rectangle-puzzle init-puzzle)
  (local
    [(define result
       (search solved? neighbours (construct-puzzle init-puzzle)))]
    (cond
      [(state? result) (state-rects result)]
      [else result])))

;; tests:
(check-expect
 (member? (make-rect 4 2 1 3) (solve-rectangle-puzzle puzz)) true)
(check-expect
 (member? (make-rect 12 2 1 5)
          (solve-rectangle-puzzle big-puzz)) true)

     
 