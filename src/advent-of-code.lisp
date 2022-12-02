(defpackage #:advent-of-code
  (:use #:cl #:uiop/stream)
  (:nicknames #:aoc)
  (:export #:read-lines #:resource-file))

(in-package :advent-of-code)

(defmacro λ (&whole whole args &body body)
  (declare (ignore args body))
  (cons 'lambda (cdr whole)))

(defun resource-file (p)
  (let ((resources (load-time-value (asdf/system:system-relative-pathname :advent-of-code-2022 "resources/"))))
    (merge-pathnames p resources)))

(defun read-lines (file &optional (parse-fn #'identity))
  (mapcar parse-fn
	  (read-file-lines (resource-file file))))
