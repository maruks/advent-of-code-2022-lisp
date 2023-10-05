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

(defun move-rope (hs tail-x tail-y head-x head-y dir len)
  (if (plusp len)
      (multiple-value-bind (next-x next-y) (ecase dir
					     (:U (values head-x (1+ head-y)))
					     (:D (values head-x (1- head-y)))
					     (:R (values (1+ head-x) head-y))
					     (:L (values (1- head-x) head-y)))
	(let* ((dx (- next-x tail-x))
	       (dy (- next-y tail-y))
	       (move-tail? (or (> (abs dx) 1) (> (abs dy) 1))))
	  (multiple-value-bind (next-tail-x next-tail-y) (if move-tail?
							     (values (+ (signum dx) tail-x) (+ (signum dy) tail-y))
							     (values tail-x tail-y))
	    (when move-tail?
	      (hs-ninsert hs (->key next-tail-x next-tail-y)))
	    (move-rope hs next-tail-x next-tail-y next-x next-y dir (1- len)))))
      (values hs tail-x tail-y head-x head-y)))

(series::defun count-visited (xs)
  (declare (optimizable-series-function))
  (let ((initial-hash-set (list-to-hs (list (->key +start-x+ +start-y+)))))
    (->> xs
	 (collect-fn '(values t fixnum fixnum fixnum fixnum)
		     (lambda () (values initial-hash-set +start-x+ +start-y+ +start-x+ +start-y+))
		     (lambda (hs tail-x tail-y head-x head-y elem)
		       (destructuring-bind (dir . len) elem
			 (move-rope hs tail-x tail-y head-x head-y dir len))))
	 (hs-count))))

(defun solution-1 ()
  (-> (read-input)
      (count-visited)))

(defun solution-2 ()
  )
