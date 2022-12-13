(defpackage #:day-4
  (:use #:cl #:aoc #:series #:rutils)
  (:shadowing-import-from #:rutils.sequence "SPLIT-IF" "SPLIT")
  (:export #:solution-1 #:solution-2))

(in-package #:day-4)

(named-readtables:in-readtable rutils-readtable)

(defun ->range (s)
  (destructuring-bind (a b c d) (split-sequence-if ^(or (char= % #\-) (char= % #\,)) s)
    (->> (list a b c d)
	 (mapcar #'parse-integer))))

(defun includes? (r)
  (destructuring-bind (a b c d) r
    (cond ((and (>= c a) (<= d b)) 1)
	  ((and (>= a c) (<= b d)) 1)
	  (t 0))))

(defun overlaps? (r)
  (destructuring-bind (a b c d) r
    (cond ((or (< b c) (< d a)) 0)
	  (t 1))))

(series::defun parse-input (stream)
  (declare (optimizable-series-function))
  (->> stream
       (map-fn t #'->range)))

(defparameter *sum-fn* #'includes?)

(series::defun number-of-tasks (stream)
  (declare (optimizable-series-function))
  (->> stream
       (map-fn 'integer *sum-fn*)
       (collect-sum)))

(defun solution-1 ()
  (->> (scan-file (resource-file "day-4-input.txt") #'read-line)
       (parse-input)
       (number-of-tasks)))

(defun solution-2 ()
  (let ((*sum-fn* #'overlaps?))
    (solution-1)))
