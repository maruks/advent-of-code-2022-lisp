(defpackage #:day-4-tests
  (:use #:cl #:cacau #:assert-p #:day-4))

(in-package #:day-4-tests)

(defsuite :day-4 ()
  (deftest "solution-1" ()
    (eq-p (solution-1) 528))
  (deftest "solution-2" ()
    (eq-p (solution-2) 881)))
