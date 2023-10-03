(defpackage #:day-8-tests
  (:use #:cl #:series #:cacau #:assert-p #:day-8))

(in-package #:day-8-tests)

(eval-when (:execute :load-toplevel :compile-toplevel)
  (series::install :macro t :shadow nil))

(defsuite :day-8 ()
  (deftest "visible-trees" ()
    (equalp-p (day-8::visible-trees (scan-range :from 0 :length 18) #(1 1 2 2 1 1 2 4 5 2 3 5 6 6 5 2 3 8)) '(17 12 8 7 2 0)))
  (deftest "solution-1" ()
    (eql-p (solution-1) 1779))
  (deftest "max-scenic-score" ()
    (let ((arr #(3 0 3 7 3
		 2 5 5 1 2
		 6 5 3 3 2
		 3 3 5 4 9
		 3 5 3 9 0)))
      (eql-p (day-8::max-scenic-score arr 5) 8)))
  (deftest "solution-2" ()
    (eql-p (solution-2) 172224)))
