(defpackage #:day-7-tests
  (:use #:cl #:cacau #:assert-p #:day-7))

(in-package #:day-7-tests)

(defsuite :day-7 ()
  (deftest "example 1" ()
    (let ((tree (day-7::file->tree "day-7-example.txt")))
      (eql-p 48381165 (day-7::compute-size tree))
      (eql-p 95437 (day-7::sum-total-sizes tree))
      (eql-p 24933642 (day-7::smallest-directory-to-delete tree))))

  (deftest "solution-1" ()
    (eql-p 1501149 (solution-1)))

  (deftest "solution-2" ()
    (eql-p 10096985 (solution-2))))
