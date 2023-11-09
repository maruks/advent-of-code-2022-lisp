(defpackage #:advent-of-code
  (:use #:cl #:uiop/stream)
  (:nicknames #:aoc)
  (:export #:read-lines #:resource-file #:λ #:print-map))

(in-package :advent-of-code)

(defmacro λ (&body body)
  (cons 'lambda body))

(defun resource-file (p)
  (let ((resources (load-time-value (asdf/system:system-relative-pathname :advent-of-code-2022 "resources/"))))
    (merge-pathnames p resources)))

(defun read-lines (file &optional (parse-fn #'identity))
  (mapcar parse-fn
	  (read-file-lines (resource-file file))))

(defun print-map (height width map)
  (loop for y from 0 to (1- height) do
    (loop for x from 0 to (1- width)
	  do (format t "~a" (gethash (cons x y) map #\.)))
    (format t "~%")))
