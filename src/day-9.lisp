(defpackage #:day-9
  (:use #:cl #:aoc #:arrows #:alexandria #:series #:hash-set)
  (:export #:solution-1 #:solution-2))

(in-package #:day-9)

(define-constant +start-x+ 10000)
(define-constant +start-y+ 10000)

(defun parse-line (s)
  (destructuring-bind (dir len) (str:split #\Space s)
    (cons (make-keyword dir) (parse-integer len))))

(series::defun read-input ()
  (declare (optimizable-series-function))
  (map-fn t #'parse-line (scan-file (resource-file "day-9-input.txt") #'read-line)))

(defun ->key (x y)
   (declare (fixnum x y))
   (declare (optimize (speed 3) (safety 0)))
   (the fixnum (logior (the fixnum (ash x 16)) y)))

(defun ->key-2 (xy)
  (destructuring-bind (x . y) xy
    (->key x y)))

(defun move-head (head dir)
  (destructuring-bind (x . y) head
    (ecase dir
      (:U (cons x (1+ y)))
      (:D (cons x (1- y)))
      (:R (cons (1+ x) y))
      (:L (cons (1- x) y)))))

(defun maybe-move (head tail)
  (destructuring-bind (head-x . head-y) head
    (destructuring-bind (tail-x . tail-y) tail
      (let* ((dx (- head-x tail-x))
	     (dy (- head-y tail-y))
	     (move-tail? (or (> (abs dx) 1) (> (abs dy) 1))))
	(multiple-value-bind (next-tail-x next-tail-y) (if move-tail?
							   (values (+ (signum dx) tail-x) (+ (signum dy) tail-y))
							   (values tail-x tail-y))
	  (cons next-tail-x next-tail-y))))))

(defun move-knots (acc knot)
  (let ((xy (maybe-move (car acc) knot)))
    (cons xy acc)))

(defun move-rope (hs knots dir len)
  (if (plusp len)
      (let* ((next-head (move-head (car knots) dir))
	     (next-knots-rev (reduce #'move-knots (cdr knots) :initial-value (list next-head))))
	(when (not (equal (last knots) (car next-knots-rev)))
	  (hs-ninsert hs (->key-2 (car next-knots-rev))))
	(move-rope hs (nreverse next-knots-rev) dir (1- len)))
      (values hs knots)))

(series::defun count-visited (number-of-knots xs)
  (declare (optimizable-series-function))
  (let* ((initial-xy (cons +start-x+ +start-y+))
	 (initial-hash-set (list-to-hs (list (->key-2 initial-xy))))
	 (initial-list (loop repeat number-of-knots collect initial-xy)))
    (->> xs
	 (collect-fn '(values t t)
		     (lambda () (values initial-hash-set initial-list))
		     (lambda (hs knots elem)
		       (destructuring-bind (dir . len) elem
			 (move-rope hs knots dir len))))
	 (hs-count))))

(defun solution-1 ()
  (->> (read-input)
      (count-visited 2)))

(defun solution-2 ()
  (->> (read-input)
      (count-visited 10)))
