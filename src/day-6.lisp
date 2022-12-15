(defpackage #:day-6
  (:use #:cl #:aoc #:series #:rutils #:arrows)
  (:shadowing-import-from #:rutils.sequence "SPLIT-IF" "SPLIT")
  (:shadowing-import-from #:rutils.misc "->" "->>")
  (:export #:solution-1 #:solution-2))

(in-package #:day-6)

(series::defun read-input ()
  (declare (optimizable-series-function))
  (-> "day-6-input.txt"
      (resource-file)
      (scan-file #'read-char)))

(series::defun find-four-character-marker (stream)
  (declare (optimizable-series-function))
  (declare (off-line-port stream))
  (->> (mapping (((a b c d) (chunk 4 1 stream)))
		(char/= a b c d))
       (until-if #'identity)
       (collect-length)))

(series::defun find-14-character-marker (stream)
  (declare (optimizable-series-function))
  (declare (off-line-port stream))
  (->> (mapping (((a b c d e f g h i j k l m n) (chunk 14 1 stream)))
		(char/= a b c d e f g h i j k l m n))
       (until-if #'identity)
       (collect-length)))

(defun solution-1 ()
  (->> (read-input)
       (find-four-character-marker)
       (+ 4)))

(defun solution-2 ()
  (->> (read-input)
       (find-14-character-marker)
       (+ 14)))
