(defpackage #:day-8
  (:use #:cl #:aoc #:arrows #:alexandria #:series)
  (:export #:solution-1 #:solution-2))

(in-package #:day-8)

(eval-when (:execute :load-toplevel :compile-toplevel)
  (series::install :macro t :shadow nil))

(defparameter *map-size* 99)

(defun read-input (filename map-size)
  (-<> filename
      (resource-file)
      (scan-file #'read-char)
      (choose-if #'digit-char-p <>)
      (map-fn 'fixnum (λ (c) (- (char-code c) 48)) <>)
      (collect `(vector * ,(* map-size map-size)) <>)))

(defun ->index (x y)
  (+ x (* y *map-size*)))

(series::defun ->row (y)
  (declare (optimizable-series-function))
  (mapping ((x (scan-range :from 0 :length *map-size*)))
	   (->index x y)))

(series::defun ->column (x)
  (declare (optimizable-series-function))
  (mapping ((y (scan-range :from 0 :length *map-size*)))
	   (->index x y)))

(series::defun ->row-reversed (y)
  (declare (optimizable-series-function))
  (mapping ((x (scan-range :from (1- *map-size*) :by -1 :downto 0)))
	   (->index x y)))

(series::defun ->column-reversed (x)
  (declare (optimizable-series-function))
  (mapping ((y (scan-range :from (1- *map-size*) :by -1 :downto 0)))
	   (->index x y)))

(series::defun visible-trees (xs arr)
  (declare (optimizable-series-function))
  (cdr (collect-fn 'list (constantly (list -1))
		   (lambda (results index)
		     (destructuring-bind (max &rest rs) results
		       (let ((height (aref arr index)))
			 (if (> height max)
			     (cons height (cons index rs))
			     (cons max rs))))) xs)))

(defun count-unique (xs &optional (prev -1) (result 0))
  (if (null xs)
      result
      (destructuring-bind (head &rest tail) xs
	(let ((unique? (< prev head)))
	  (count-unique tail (if unique? head prev) (if unique? (1+ result) result))))))

(defun all-visible-trees (arr size)
  (let ((*map-size* size))
    (-<>>
     (iota *map-size*)
     (mappend (lambda (i) (append (visible-trees (->column i) arr)
				  (visible-trees (->column-reversed i) arr)
				  (visible-trees (->row i) arr)
				  (visible-trees (->row-reversed i) arr))))
     (sort <> #'<)
     (count-unique))))

(defun solution-1 ()
  (-> (read-input "day-8-input.txt" 99)
      (all-visible-trees 99)))

(defun scenic-score (x y dx dy arr &optional (result 0) (prev-height -1))
  (if (or (negative-integer-p x) (negative-integer-p y) (<= *map-size* x) (<= *map-size* y))
      result
      (let ((height (aref arr (->index x y))))
	(cond
	  ((negative-integer-p prev-height) (scenic-score (+ x dx) (+ y dy) dx dy arr result height))
	  ((> prev-height height) (scenic-score (+ x dx) (+ y dy) dx dy arr (1+ result) prev-height))
	  (t (1+ result))))))

(defun tree-scenic-score (x y arr)
  (* (scenic-score x y 0 1 arr)
     (scenic-score x y 1 0 arr)
     (scenic-score x y 0 -1 arr)
     (scenic-score x y -1 0 arr)))

(defun all-coords ()
  (->> (iota *map-size*)
       (mappend (λ (x) (mapcar (λ (y) (cons x y)) (iota *map-size*))))))

(defun max-scenic-score (arr size)
  (let ((*map-size* size))
    (->> (all-coords)
	 (mapcar (λ (xy) (destructuring-bind (x . y) xy
			   (tree-scenic-score x y arr))))
	 (apply #'max))))

(defun solution-2 ()
  (-> (read-input "day-8-input.txt" 99)
      (max-scenic-score 99)))
