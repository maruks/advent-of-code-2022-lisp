(defpackage #:day-2-tests
  (:use #:cl #:cacau #:assert-p #:day-2 #:series))

(in-package #:day-2-tests)

(eval-when (:execute :load-toplevel :compile-toplevel)
  (series::install :macro t :shadow nil))

(defsuite :day-2 ()
  (deftest "total-score" ()
    (eq-p (day-2::total-score #z((:A . :Y) (:B . :X) (:C . :Z))) 15))
  (deftest "solution-1" ()
    (eq-p (solution-1) 13526))
  (deftest "solution-2" ()
    (eq-p (solution-2) 14204)))
