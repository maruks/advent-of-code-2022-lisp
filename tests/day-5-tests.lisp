(defpackage #:day-5-tests
  (:use #:cl #:cacau #:assert-p #:day-5))

(in-package #:day-5-tests)

(defsuite :day-5 ()
  (deftest "solution-1" ()
    (equal-p (solution-1) "JCMHLVGMG"))
  (deftest "solution-2" ()
    (equal-p (solution-2) "LVMRWSSPZ")))
