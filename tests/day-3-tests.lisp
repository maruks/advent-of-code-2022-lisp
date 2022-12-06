(defpackage #:day-3-tests
  (:use #:cl #:cacau #:assert-p #:day-3 #:series))

(in-package #:day-3-tests)

(defparameter *test-input* '("vJrwpWtwJgWrhcsFMMfFFhFp"
			     "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL"
			     "PmmdzqPrVvPwwTWBwg"
			     "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn"
			     "ttgJtRGJQctTZtZT"
			     "CrZsJsPPZsGzwwsLwLmpwMDw"))

(defparameter *test-input-2* '("vJrwpWtwJgWrhcsFMMfFFhFp"
			       "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL"
			       "PmmdzqPrVvPwwTWBwg"
			       "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn"
			       "ttgJtRGJQctTZtZT"
			       "CrZsJsPPZsGzwwsLwLmpwMDw"))

(defsuite :day-3 ()
  (deftest "sum-of-priorities" ()
    (eq-p (day-3::sum-of-priorities (scan *test-input*)) 157))
  (deftest "solution-1" ()
    (eq-p (solution-1) 7967))
  (deftest "solution-2" ()
    (eq-p (solution-2) 2716))
  )
