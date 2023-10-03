(defpackage #:day-1-tests
  (:use #:cl #:cacau #:assert-p #:day-1))

(in-package #:day-1-tests)

(defsuite :day-1 ()
  (deftest "insert-if-bigger" ()
    (equal-p (day-1::insert-if-bigger '(3 6 8) 7) '(6 7 8)))
  (deftest "solution 1" ()
    (eql-p (solution-1) 70720))
  (deftest "solution 2" ()
    (eql-p (solution-2) 207148)))
