(defpackage #:day-5
  (:use #:cl #:aoc #:series #:arrows)
  (:export #:solution-1 #:solution-2))

(in-package #:day-5)

(eval-when (:execute :load-toplevel :compile-toplevel)
  (series::install :macro t :shadow nil))

;;     [W]         [J]     [J]
;;     [V]     [F] [F] [S] [S]
;;     [S] [M] [R] [W] [M] [C]
;;     [M] [G] [W] [S] [F] [G]     [C]
;; [W] [P] [S] [M] [H] [N] [F]     [L]
;; [R] [H] [T] [D] [L] [D] [D] [B] [W]
;; [T] [C] [L] [H] [Q] [J] [B] [T] [N]
;; [G] [G] [C] [J] [P] [P] [Z] [R] [H]
;;  1   2   3   4   5   6   7   8   9

(defun initial-crates ()
  (let ((array (make-array '(9))))
    (setf (aref array 0) (coerce "WRTG" 'list))
    (setf (aref array 1) (coerce "WVSMPHCG" 'list))
    (setf (aref array 2) (coerce "MGSTLC" 'list))
    (setf (aref array 3) (coerce "FRWMDHJ" 'list))
    (setf (aref array 4) (coerce "JFWSHLQP" 'list))
    (setf (aref array 5) (coerce "SMFNDJP" 'list))
    (setf (aref array 6) (coerce "JSCGFDBZ" 'list))
    (setf (aref array 7) (coerce "BTR" 'list))
    (setf (aref array 8) (coerce "CLWNH" 'list))
    array))

(defun ->procedure (s)
  (destructuring-bind (_1 num _2 from _3 to) (str:split " " s)
    (declare (ignore _1 _2 _3))
    (mapcar #'parse-integer (list num from to))))

(series::defun read-input ()
  (declare (optimizable-series-function))
  (-<> "day-5-input.txt"
       (resource-file)
       (scan-file #'read-line)
       (#M->procedure <>)))

(defun move-crate (crates num from to)
  (when (plusp num)
    (push (pop (aref crates (1- from))) (aref crates (1- to)))
    (move-crate crates (1- num) from to)))

(defun move-crate-2 (crates num from to)
  (let ((from-list (aref crates (1- from))))
    (multiple-value-bind (head tail) (split-list from-list num)
      (setf (aref crates (1- from)) tail)
      (setf (aref crates (1- to)) (append head (aref crates (1- to)))))))

(defparameter *move-fn* #'move-crate)

(series::defun move-all-crates (stream)
  (declare (optimizable-series-function))
  (->> stream
       (collecting-fn t #'initial-crates (λ (crates procedure)
					   (apply *move-fn* (cons crates procedure))
					   crates))
       (collect)))

(defun split-list (list count)
  (values (subseq list 0 count) (nthcdr count list)))

(defun top-crates (crates)
  (-<> crates
       (coerce 'list)
       (mapcar #'car <>)
       (coerce 'string)))

(defun solution-1 ()
  (->> (read-input)
       (move-all-crates)
       (car)
       (top-crates)))

(defun solution-2 ()
  (let ((*move-fn* #'move-crate-2))
    (solution-1)))
