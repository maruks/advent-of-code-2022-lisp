(defpackage #:day-2-tests
  (:use #:cl #:cacau #:assert-p #:day-2 #:series))

(in-package #:day-2-tests)

(defsuite :day-2 ()
  (deftest "total-score" ()
    (eq-p (day-2::total-score (day-2::parse-input (scan '("A Y" "B X" "C Z")))) 15))
  (deftest "solution-1" ()
    (eq-p (solution-1) 12586))
  (deftest "solution-2" ()
    (eq-p (solution-2) 13193)))
