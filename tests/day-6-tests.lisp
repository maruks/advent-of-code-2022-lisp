(defpackage #:day-6-tests
  (:use #:cl #:cacau #:assert-p #:day-6))

(in-package #:day-6-tests)

(defsuite :day-6 ()
  (deftest "solution-1" ()
    (eql-p (solution-1) 1766))
  (deftest "solution-2" ()
    (eql-p (solution-2) 2383)))
