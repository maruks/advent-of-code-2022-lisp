(defpackage #:day-6-tests
  (:use #:cl #:cacau #:assert-p #:day-6))

(in-package #:day-6-tests)

(defsuite :day-6 ()
  (deftest "solution-1" ()
    (eql-p 1892 (solution-1)))
  (deftest "solution-2" ()
    (eql-p 2313 (solution-2))))
