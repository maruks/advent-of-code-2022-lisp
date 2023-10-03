(defpackage #:day-8
  (:use #:cl #:aoc #:arrows #:alexandria #:series)
  (:export #:solution-1 #:solution-2))

(in-package #:day-8)

(eval-when (:execute :load-toplevel :compile-toplevel)
  (series::install :macro t :shadow nil))

(define-constant +map-size+ 99)

(defun read-input (filename)
  (-<> filename
      (resource-file)
      (scan-file #'read-char)
      (choose-if #'digit-char-p <>)
      (map-fn 'fixnum (λ (c) (- (char-code c) 48)) <>)
      (collect `(vector * ,(* +map-size+ +map-size+)) <>)))

(defun ->idx (x y)
  (+ x (* y +map-size+)))

(series::defun ->row (y)
  (declare (optimizable-series-function))
  (mapping ((x (scan-range :from 0 :length +map-size+)))
	   (->idx x y)))

(series::defun ->column (x)
  (declare (optimizable-series-function))
  (mapping ((y (scan-range :from 0 :length +map-size+)))
	   (->idx x y)))

(series::defun ->row-reversed (y)
  (declare (optimizable-series-function))
  (mapping ((x (scan-range :from (1- +map-size+) :by -1 :downto 0)))
	   (->idx x y)))

(series::defun ->column-reversed (x)
  (declare (optimizable-series-function))
  (mapping ((y (scan-range :from (1- +map-size+) :by -1 :downto 0)))
	   (->idx x y)))

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

(defun all-visible-trees (arr)
  (-<>>
   (iota +map-size+)
   (mappend (lambda (i) (append (visible-trees (->column i) arr)
				(visible-trees (->column-reversed i) arr)
				(visible-trees (->row i) arr)
				(visible-trees (->row-reversed i) arr))))
   (sort <> #'<)
   (count-unique)))

(defun solution-1 ()
  (->> "day-8-input.txt"
       (read-input)
       (all-visible-trees)))

(defun solution-2 ()
  )
