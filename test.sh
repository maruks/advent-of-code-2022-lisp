#!/bin/bash

sbcl --non-interactive --eval "(ql:quickload :advent-of-code-2022/tests)" --eval "(asdf:test-system :advent-of-code-2022)"
