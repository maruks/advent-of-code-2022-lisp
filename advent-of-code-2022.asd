;;;; advent-of-code-2022.asd

(defsystem "advent-of-code-2022"
  :description "https://adventofcode.com/2022"
  :author "Maris Orbidans"
  :license "Public license"
  :version "0.0.1"
  :serial t
  :depends-on (:series :str :alexandria :arrows :split-sequence)
  :build-operation "program-op"
  :build-pathname "advent-of-code"
  :entry-point "main:main"

  :components ((:module "src"
		:components ((:file "advent-of-code")
			     (:file "day-1")
			     (:file "day-2")
			     (:file "day-3")
			     (:file "day-4")
			     (:file "day-5")
			     (:file "day-6")
			     (:file "day-7")
			     (:file "main"))))
  :in-order-to ((test-op (test-op "advent-of-code-2022/tests"))))

(defsystem "advent-of-code-2022/tests"
  :license "Public license"
  :depends-on (:advent-of-code-2022
	       :cacau
	       :alexandria
	       :assert-p)
  :serial t
  :components ((:module "tests"
		:components ((:file "day-1-tests")
			     (:file "day-2-tests")
			     (:file "day-3-tests")
			     (:file "day-4-tests")
			     (:file "day-5-tests")
			     (:file "day-6-tests")
			     (:file "day-7-tests")
			     )))
  :perform (test-op (o c) (symbol-call 'cacau 'run :colorful t :reporter :list)))
