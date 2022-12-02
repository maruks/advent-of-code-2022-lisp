(defpackage #:day-1-tests
  (:use #:cl #:cacau #:assert-p #:day-1))

(in-package #:day-1-tests)

(defsuite :day-1 ()
  (deftest "insert-if-bigger" ()
    (equal-p '(6 7 8) (day-1::insert-if-bigger '(3 6 8) 7)))
  (deftest "solution 1" ()
    (eql-p 68802 (solution-1)))
  (deftest "solution 2" ()
    (eql-p 205370 (solution-2))))
