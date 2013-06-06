;;;; clispreadings.asd

(asdf:defsystem #:clispreadings
  :serial t
  :description "Web app for device readings"
  :author "rohshall@gmail.com"
  :license "BSD"
  :depends-on (#:ningle
               #:clack
               #:hunchentoot
               #:dbi
               #:cl-json)
  :components ((:file "package")
               (:file "clispreadings")))

