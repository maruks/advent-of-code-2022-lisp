(defpackage #:advent-of-code
  (:use #:cl #:uiop/stream)
  (:nicknames #:aoc)
  (:export #:read-lines #:resource-file #:λ))

(in-package :advent-of-code)

(defmacro λ (&body body)
  (cons 'lambda body))

(defun resource-file (p)
  (let ((resources (load-time-value (asdf/system:system-relative-pathname :advent-of-code-2022 "resources/"))))
    (merge-pathnames p resources)))

(defun read-lines (file &optional (parse-fn #'identity))
  (mapcar parse-fn
	  (read-file-lines (resource-file file))))
