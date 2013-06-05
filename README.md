# clispreadings

REST-based Common Lisp web application for device readings

## Installation

If this is a new machine, install sbcl from the package manager (sudo apt-get insall sbcl). 

Start with a fresh .sbclrc file:
```
cat > ~/.sblrc
;; -*-Lisp-*-
(require 'asdf)
```

Get quicklisp set up
```
mkdir quicklisp && cd quicklisp
curl -O http://beta.quicklisp.org/quicklisp.lisp
```
Start up sbcl 
```
(load "quicklisp.lisp")
(quicklisp-quickstart:install)
(ql:add-to-init-file)
```
Now, quicklisp is added to .sblcrc.

Use it to load clispreadings:
```
(ql:quickload "clispreadings")
```
