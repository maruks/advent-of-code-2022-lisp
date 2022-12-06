(defpackage #:day-2
  (:use #:cl #:aoc #:series #:rutils)
  (:shadowing-import-from #:rutils.sequence "SPLIT-IF" "SPLIT")
  (:export #:solution-1 #:solution-2))

(in-package #:day-2)

(named-readtables:in-readtable rutils-readtable)

;; A for Rock, B for Paper, and C for Scissors
;; X for Rock, Y for Paper, and Z for Scissors.
(defparameter *draw* #h(:A :X
			:B :Y
			:C :Z))

(defparameter *lose* #h(:A :Z
			:B :X
			:C :Y))

(defparameter *win* #h(:A :Y
		       :B :Z
		       :C :X))

(defparameter *score* #h(:X 1
			 :Y 2
			 :Z 3))

(defun ->score (p)
  (with-pair (l r) p
    (+ (gethash r *score*)
	(cond ((eq r (gethash l *draw*)) 3)
	      ((eq r (gethash l *lose*)) 0)
	      (t 6)))))

(series::defun parse-input (stream)
  (declare (optimizable-series-function))
  (->> stream
       (map-fn t ^(->> %
		       (split-string)
		       (mapcar #'ensure-keyword)
		       (apply #'pair)))))

(series::defun total-score (stream)
  (declare (optimizable-series-function))
  (->> stream
       (map-fn 'integer #'->score)
       (collect-sum)))

(series::defun choose-shape (stream)
  (declare (optimizable-series-function))
  (mapping ((p stream))
	   (with-pair (l r) p
	     (pair l (ecase r
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
