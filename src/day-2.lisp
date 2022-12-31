(defpackage #:day-2
  (:use #:cl #:aoc #:series #:alexandria #:arrows)
  (:export #:solution-1 #:solution-2))

(in-package #:day-2)

;; A for Rock, B for Paper, and C for Scissors
;; X for Rock, Y for Paper, and Z for Scissors.
(defparameter *draw* (alist-hash-table '((:A . :X)
					 (:B . :Y)
					 (:C . :Z))))

(defparameter *lose* (alist-hash-table '((:A . :Z)
					 (:B . :X)
					 (:C . :Y))))

(defparameter *win* (alist-hash-table '((:A . :Y)
					(:B . :Z)
					(:C . :X))))

(defparameter *score* (alist-hash-table '((:X . 1)
					  (:Y . 2)
					  (:Z . 3))))

(defun ->score (p)
  (destructuring-bind (l . r) p
    (+ (gethash r *score*)
	(cond ((eq r (gethash l *draw*)) 3)
	      ((eq r (gethash l *lose*)) 0)
	      (t 6)))))

(series::defun parse-input (stream)
  (declare (optimizable-series-function))
  (->> stream
       (map-fn t (λ (x) (->> x
			     (str:words)
			     (mapcar #'make-keyword)
			     (apply #'cons))))))

(series::defun total-score (stream)
  (declare (optimizable-series-function))
  (->> stream
       (map-fn 'integer #'->score)
       (collect-sum)))

(series::defun choose-shape (stream)
  (declare (optimizable-series-function))
  (mapping ((p stream))
	   (destructuring-bind (l . r) p
	     (cons l (ecase r
		       (:X (gethash l *lose*))
		       (:Y (gethash l *draw*))
		       (:Z (gethash l *win*)))))))

(defun solution-1 ()
  (->> (scan-file (resource-file "day-2-input.txt") #'read-line)
       (parse-input)
       (total-score)))

(defun solution-2 ()
  (->> (scan-file (resource-file "day-2-input.txt") #'read-line)
       (parse-input)
       (choose-shape)
       (total-score)))
