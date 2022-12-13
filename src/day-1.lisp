(defpackage #:day-1
  (:use #:cl #:aoc #:series #:rutils)
  (:shadowing-import-from #:rutils.sequence "SPLIT-IF" "SPLIT")
  (:export #:solution-1 #:solution-2))

(in-package #:day-1)

(defun int-or-zero (s)
  (if (blankp s) 0 (parse-integer s)))

(series::defun read-input ()
  (declare (optimizable-series-function))
  (map-fn 'integer #'int-or-zero (scan-file (resource-file "day-1-input.txt") #'read-line)))

(defun insert-if-bigger (xs elem)
  (if (> elem (car xs))
      (cdr (merge 'list (list elem) xs #'<))
      xs))

(defun find-top (top-3 prev xs)
  (with (((h &rest r) xs))
    (cond ((null r) (insert-if-bigger top-3 (+ h prev)))
	  ((zerop h) (find-top (insert-if-bigger top-3 prev) 0 r))
	  (t (find-top top-3 (+ h prev) r)))))

(defun solution-1 ()
  (->> (read-input)
       (collecting-fn 'integer (lambda () 0) (lambda (s elem) (if (zerop elem) elem (+ s elem))))
       (collect-max)))

(defun solution-2 ()
  (->> (read-input)
       (collect)
       (find-top '(0 0 0) 0)
       (reduce #'+)))
