# Advent of Code 2022

### SBCL

#### Test

    sbcl --non-interactive --eval "(ql:quickload :advent-of-code-2022/tests)" --eval "(asdf:test-system :advent-of-code-2022)"

#### Run

	sbcl --non-interactive --eval "(ql:quickload :advent-of-code-2022)" --eval "(main:main)"

#### Build binary

	sbcl --non-interactive --eval "(ql:quickload :advent-of-code-2022)" --eval "(asdf:make :advent-of-code-2022)"
