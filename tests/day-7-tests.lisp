(defpackage #:day-7-tests
  (:use #:cl #:cacau #:assert-p #:day-7))

(in-package #:day-7-tests)

(defsuite :day-7 ()
  (deftest "example 1" ()
    (let ((tree (day-7::file->tree "day-7-example.txt")))
      (eql-p (day-7::compute-size tree) 48381165)
      (eql-p (day-7::sum-total-sizes tree) 95437)
      (eql-p (day-7::smallest-directory-to-delete tree) 24933642)))

  (deftest "solution-1" ()
    (eql-p (solution-1) 919137))

  (deftest "solution-2" ()
    (eql-p (solution-2) 2877389)))
