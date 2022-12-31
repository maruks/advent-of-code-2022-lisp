(defpackage #:day-3
  (:use #:cl #:aoc #:series #:arrows #:alexandria)
  (:export #:solution-1 #:solution-2))

(in-package #:day-3)

(defun split-in-half (s)
  (let ((l (truncate (length s) 2)))
    (cons (str:substring 0 l s) (str:substring l t s))))

(defun ->priority (c)
  (let ((code (char-code c)))
    (if (upper-case-p c)
	(- code 38)
	(- code 96))))

(defun unique-items (s)
  (remove-duplicates (coerce s 'list)))

(defun ->item (s)
  (destructuring-bind (l . r) (split-in-half s)
    (car (intersection (unique-items l) (unique-items r)))))

(series::defun sum-of-priorities (stream)
  (declare (optimizable-series-function))
  (->> stream
       (map-fn 'integer (compose #'->priority #'->item))
       (collect-sum)))

(defun solution-1 ()
     (->> (scan-file (resource-file "day-3-input.txt") #'read-line)
	  (sum-of-priorities)))

(series::defun ->badges (xs)
  (declare (optimizable-series-function))
  (declare (off-line-port xs))
  (series::multiple-value-bind (a b c) (chunk 3 3 xs)
    (->> (map-fn 'integer (λ (a b c)
			    (->> (list a b c)
				 (mapcar #'unique-items)
				 (reduce #'intersection)
				 (car)
				 ->priority)) a b c)
	 (collect-sum))))

(defun solution-2 ()
  (-> (resource-file "day-3-input.txt")
      (scan-file #'read-line)
      (->badges)))
