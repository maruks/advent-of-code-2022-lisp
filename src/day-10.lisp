(defpackage #:day-10
  (:use #:cl #:aoc #:arrows #:alexandria #:series #:hash-set)
  (:export #:solution-1 #:solution-2))

(in-package #:day-10)

(defparameter *file-name* "day-10-input.txt")

(defun parse-line (s)
  (destructuring-bind (cmd &optional arg) (str:split #\Space s)
    (ecase (-> cmd str:upcase make-keyword)
      (:ADDX (some-> arg parse-integer))
      (:NOOP 0))))

(series::defun read-input ()
  (declare (optimizable-series-function))
  (map-fn 'integer #'parse-line (scan-file (resource-file *file-name*) #'read-line)))

(series::defun sum-signal-strengths (xs cycles-list)
  (declare (optimizable-series-function))
  (let ((cycles-set (list-to-hs cycles-list)))
    (->> xs
	 (collect-fn 'list (constantly (list 0 1 1))
		     (lambda (acc input)
		       (destructuring-bind (sum cycle register) acc
			 (let* ((add-x? (not (zerop input)))
				(next-cycle (if add-x? (+ 2 cycle) (1+ cycle)))
				(next-register (+ register input))
				(add-to-sum-cycle (cond
						    ((hs-memberp cycles-set cycle) cycle)
						    ((and add-x? (hs-memberp cycles-set (1+ cycle))) (1+ cycle))))
				(next-sum (if add-to-sum-cycle (+ sum (* add-to-sum-cycle register)) sum)))
			   (list next-sum next-cycle next-register)))))
	 (car))))

(defun solution-1 ()
  (sum-signal-strengths (read-input) (iota 6 :start 20 :step 40)))

;; ------ part 2 ------

(defparameter *crt-width* 40)
(defparameter *crt-height* 6)

(series::defun all-register-values (xs)
  (declare (optimizable-series-function))
  (->> xs
       (collect-fn 'list (constantly (list nil 1 1))
		   (lambda (acc input)
		     (destructuring-bind (result cycle register) acc
		       (let* ((add-x? (not (zerop input)))
			      (next-cycle (if add-x? (+ 2 cycle) (1+ cycle)))
			      (next-register (+ register input))
			      (next-result-0 (cons register result))
			      (next-result (if add-x? (cons register next-result-0) next-result-0)))
			 (list next-result next-cycle next-register)))))
       (car)
       (nreverse)))

(defun draw (map index xs)
  (when xs
    (destructuring-bind (register &rest tail) xs
      (multiple-value-bind (y x) (truncate index *crt-width*)
	(let ((pixel? (< (abs (- x register)) 2)))
	  (when pixel?
	    (setf (gethash (cons x y) map) #\#))))
      (draw map (1+ index) tail))))

(defun solution-2 ()
  (let ((map (make-hash-table :test #'equal :size (* *crt-width* *crt-height*))))
    (->> (read-input)
	 (all-register-values)
	 (draw map 0))
    (print-map *crt-height* *crt-width* map)))
