(defpackage #:day-8-tests
  (:use #:cl #:series #:cacau #:assert-p #:day-8))

(in-package #:day-8-tests)

(eval-when (:execute :load-toplevel :compile-toplevel)
  (series::install :macro t :shadow nil))

(defsuite :day-8 ()
  (deftest "visible-trees" ()
    (equalp-p (day-8::visible-trees (scan-range :from 0 :length 18) #(1 1 2 2 1 1 2 4 5 2 3 5 6 6 5 2 3 8)) '(17 12 8 7 2 0)))
   (deftest "solution-1" ()
     (eql-p (solution-1) 1779)))
