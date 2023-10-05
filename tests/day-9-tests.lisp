(defpackage #:day-9-tests
  (:use #:cl #:series #:cacau #:assert-p #:day-9))

(in-package #:day-9-tests)

(eval-when (:execute :load-toplevel :compile-toplevel)
  (series::install :macro t :shadow nil))

(defsuite :day-9 ()
  (deftest "count-visited" ()
    (eql-p (day-9::count-visited #Z((:R . 4) (:U . 4) (:L . 3) (:D . 1) (:R . 4) (:D . 1) (:L . 5) (:R . 2))) 13))
  (deftest "solution-1" ()
    (eql-p (solution-1) 6087)))