(defpackage :main
  (:use :cl :uiop :uiop/stream)
  (:export :main))

(in-package :main)

(defmacro day (number &optional name)
  (flet ((solution (n)
	   (find-symbol (format nil "SOLUTION-~a" n) (format nil "DAY-~a" number) ))
	 (label (n)
	   (format nil "--- Day ~a~a ---" n (if name (concatenate 'string ": " name) ""))))
    `(progn
       (println ,(label number))
       (println (,(solution 1)))
       (println (,(solution 2))))))

(defun run ()
  (day 1 "Calorie Counting")
  (day 2 "Rock Paper Scissors")
  (day 3 "Rucksack Reorganization")
  (day 4 "Camp Cleanup")
  (day 5 "Supply Stacks")
  (day 6 "Tuning Trouble")
  (day 7 "No Space Left On Device")
  )

(defun main ()
  (call-with-fatal-condition-handler #'run))
