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

(defun maybe-move (head-x head-y tail-x tail-y)
  (let* ((dx (- head-x tail-x))
	 (dy (- head-y tail-y))
	 (move-tail? (or (> (abs dx) 1) (> (abs dy) 1))))
    (multiple-value-bind (next-tail-x next-tail-y) (if move-tail?
						       (values (+ (signum dx) tail-x) (+ (signum dy) tail-y))
						       (values tail-x tail-y))
      (values next-tail-x next-tail-y move-tail?))))

(defun move-head (x y dir)
  (ecase dir
    (:U (values x (1+ y)))
    (:D (values x (1- y)))
    (:R (values (1+ x) y))
    (:L (values (1- x) y))))

(defun move-rope (hs head-x head-y tail-x tail-y dir len)
  (if (plusp len)
      (multiple-value-bind (next-x next-y) (move-head head-x head-y dir)
	(multiple-value-bind (next-tail-x next-tail-y moved?) (maybe-move next-x next-y tail-x tail-y)
	  (when moved?
	    (hs-ninsert hs (->key next-tail-x next-tail-y)))
	  (move-rope hs next-x next-y next-tail-x next-tail-y dir (1- len))))
      (values hs tail-x tail-y head-x head-y)))

(series::defun count-visited (xs)
  (declare (optimizable-series-function))
  (let ((initial-hash-set (list-to-hs (list (->key +start-x+ +start-y+)))))
    (->> xs
	 (collect-fn '(values t fixnum fixnum fixnum fixnum)
		     (lambda () (values initial-hash-set +start-x+ +start-y+ +start-x+ +start-y+))
		     (lambda (hs tail-x tail-y head-x head-y elem)
		       (destructuring-bind (dir . len) elem
			 (move-rope hs head-x head-y tail-x tail-y dir len))))
	 (hs-count))))

(defun solution-1 ()
  (-> (read-input)
      (count-visited)))

;; --------------------------------- part 2 ----------------------

(defun move-head-2 (head dir)
  (destructuring-bind (x . y) head
    (multiple-value-bind (x y) (move-head x y dir)
      (cons x y))))

(defun ->key-2 (xy)
  (destructuring-bind (x . y) xy
    (->key x y)))

(defun maybe-move-2 (head tail)
  (destructuring-bind (head-x . head-y) head
    (destructuring-bind (tail-x . tail-y) tail
      (multiple-value-bind (x y) (maybe-move head-x head-y tail-x tail-y)
	(cons x y)))))

(defun move-knots (acc knot)
  (let ((xy (maybe-move-2 (car acc) knot)))
    (cons xy acc)))

(defun move-rope-2 (hs knots dir len)
  (if (plusp len)
      (let* ((next-head (move-head-2 (car knots) dir))
	     (next-knots-rev (reduce #'move-knots (cdr knots) :initial-value (list next-head))))
	(when (not (equal (last knots) (car next-knots-rev)))
	  (hs-ninsert hs (->key-2 (car next-knots-rev))))
	(move-rope-2 hs (nreverse next-knots-rev) dir (1- len)))
      (values hs knots)))

(series::defun count-visited-2 (xs)
  (declare (optimizable-series-function))
  (let* ((initial-xy (cons +start-x+ +start-y+))
	 (initial-hash-set (list-to-hs (list (->key-2 initial-xy))))
	 (initial-list (loop repeat 10 collect initial-xy)))
    (->> xs
	 (collect-fn '(values t t)
		     (lambda () (values initial-hash-set initial-list))
		     (lambda (hs knots elem)
		       (destructuring-bind (dir . len) elem
			 (move-rope-2 hs knots dir len))))
	 (hs-count))))

(defun solution-2 ()
  (-> (read-input)
      (count-visited-2)))
