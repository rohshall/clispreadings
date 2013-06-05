;;;; clispreadings.asd

(asdf:defsystem #:clispreadings
  :serial t
  :description "Web app for device readings"
  :author "rohshall@gmail.com"
  :license "BSD"
  :depends-on (#:ningle
               #:hunchentoot
               #:dbi
               #:yason)
  :components ((:file "package")
               (:file "clispreadings")))

