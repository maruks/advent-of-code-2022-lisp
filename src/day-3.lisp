(defpackage #:day-3
  (:use #:cl #:aoc #:series #:rutils)
  (:shadowing-import-from #:rutils.sequence "SPLIT-IF" "SPLIT")
  (:export #:solution-1 #:solution-2))

(in-package #:day-3)

(named-readtables:in-readtable rutils-readtable)

(defun ->hash-set (s)
  (apply #'hash-set 'eql (coerce s 'list)))

(defun split-in-half (s)
  (let ((l (truncate (length s) 2)))
    (pair (substr s 0 l) (substr s l))))

(defun ->priority (c)
  (let ((code (char-code c)))
    (if (upper-case-p c)
	(- code 38)
	(- code 96))))

(defun ->item (s)
  (with-pair (l r) (split-in-half s)
    (car (hash-table-keys (inter# (->hash-set l) (->hash-set r))))))

(series::defun sum-of-priorities (stream)
  (declare (optimizable-series-function))
  (->> stream
       (map-fn 'integer (=> ->priority ->item))
       (collect-sum)))

(defun solution-1 ()
     (->> (scan-file (resource-file "day-3-input.txt") #'read-line)
	  (sum-of-priorities)))

(defun input-2 ()
  (collect
      (mapping (((a b c) (chunk 3 3 (scan-file (resource-file "day-3-input.txt") #'read-line))))
	       (list a b c))))

(defun solution-2 ()
  (->> (input-2)
       (mapcar ^(->> %
		     (mapcar #'->hash-set)
		     (reduce #'inter#)
		     (hash-table-keys)
		     (car)
		     ->priority) )
       (reduce #'+)))
