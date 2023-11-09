(defpackage #:day-10-tests
  (:use #:cl #:series #:cacau #:assert-p #:day-10))

(in-package #:day-10-tests)

(defsuite :day-10 ()
  (deftest "example 1" ()
    (let ((day-10::*file-name* "day-10-example-1.txt"))
      (eql-p (solution-1) 13140)))
  (deftest "solution 1" ()
    (eql-p (solution-1) 17020))
  )
