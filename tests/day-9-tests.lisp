(defpackage #:day-9-tests
  (:use #:cl #:series #:cacau #:assert-p #:day-9))

(in-package #:day-9-tests)

(eval-when (:execute :load-toplevel :compile-toplevel)
  (series::install :macro t :shadow nil))

(defsuite :day-9 ()
  (deftest "count-visited" ()
    (eql-p (day-9::count-visited 2 #Z((:R . 4) (:U . 4) (:L . 3) (:D . 1) (:R . 4) (:D . 1) (:L . 5) (:R . 2))) 13)
    (eql-p (day-9::count-visited 10 #Z((:R . 4) (:U . 4) (:L . 3) (:D . 1) (:R . 4) (:D . 1) (:L . 5) (:R . 2))) 1)
    (eql-p (day-9::count-visited 10 #Z((:R . 5) (:U . 8) (:L . 8) (:D . 3) (:R . 17) (:D . 10) (:L . 25) (:U . 20))) 36))
  (deftest "solution-1" ()
    (eql-p (solution-1) 6087))
  (deftest "solution-2" ()
    (eql-p (solution-2) 2493)))
