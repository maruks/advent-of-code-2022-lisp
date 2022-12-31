(defpackage #:day-7
  (:use #:cl #:aoc #:series #:arrows #:alexandria)
  (:export #:solution-1 #:solution-2))

(in-package #:day-7)

(defun ->command (s)
  (destructuring-bind (a b &optional c) (str:split " " s)
    (cond ((equal (list a b) '("$" "cd")) (when (string/= "/" c)
					      (cons :cd c)))
	  ((equal (list a b) '("$" "ls")) nil)
	  ((string= a "dir") (cons :dir b))
	  (t (cons :file (cons b (parse-integer a)))))))

(defstruct node
  (size 0 :type fixnum)
  (files nil :type list)
  (children nil :type list)
  parent)

(defun update-tree (tree cmd)
  (destructuring-bind (a . b) cmd
    (ecase a
      (:cd (if (string= b "..")
	       (node-parent tree)
	       (cdr (assoc b (node-children tree) :test #'string=))))
      (:dir (progn (when (null (assoc b (node-children tree) :test #'string=))
		     (push (cons b (make-node :parent tree)) (node-children tree)))
		   tree))
      (:file (progn (when (null (assoc (car b) (node-files tree) :test #'string=))
		      (push b (node-files tree)))
		    tree)))))

(series::defun read-input (filename)
  (declare (optimizable-series-function))
  (-<> filename
      (resource-file)
      (scan-file #'read-line)
      (map-fn t #'->command <>)
      (choose)))

(series::defun build-tree (stream)
  (declare (optimizable-series-function))
  (->> stream
       (collecting-fn t #'make-node #'update-tree)
       (collect)))

(defun find-root (node)
  (if (null (node-parent node))
      node
      (find-root (node-parent node))))

(defun file->tree (filename)
  (->> filename
       (read-input)
       (build-tree)
       (car)
       (find-root)))

(defun compute-size (node)
  (let* ((f-sizes (mapcar #'cdr (node-files node)))
	 (d-sizes (mapcar (compose #'compute-size #'cdr) (node-children node)))
	 (total (-<> (concatenate 'list f-sizes d-sizes)
		     (reduce #'+ <> :initial-value 0))))
    (setf (node-size node) total)
    total))

(defun sum-total-sizes (node)
  (let ((size (node-size node))
	(d-sizes (mapcar (compose #'sum-total-sizes #'cdr) (node-children node))))
    (reduce #'+ d-sizes :initial-value (if (>= 100000 size) size 0))))

(defun dir-sizes (tree)
  (cons (node-size tree) (mapcan (compose #'dir-sizes #'cdr) (node-children tree))))

(defun smallest-directory-to-delete (tree)
  (let* ((total (node-size tree))
	 (unused (- 70000000 total))
	 (delete-size (- 30000000 unused))
	 (sizes (sort (dir-sizes tree) #'<)))
    (find-if (curry #'<= delete-size) sizes)))

(defun solution-1 ()
  (let ((tree (file->tree "day-7-input.txt")))
    (compute-size tree)
    (sum-total-sizes tree)))

(defun solution-2 ()
  (let ((tree (file->tree "day-7-input.txt")))
    (compute-size tree)
    (smallest-directory-to-delete tree)))
