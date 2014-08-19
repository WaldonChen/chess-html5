;;;; chess.asd

(asdf:defsystem #:chess
  :serial t
  :description "Chinese Chess"
  :author "CHEN Junshi <waldonchen@gmail.com"
  :license "BSD License"
  :depends-on (#:hunchentoot
               #:parenscript
               #:cl-who
               #:cl-css
               #:cl-svg)
  :components ((:file "package")
               (:file "chess-man")
               (:file "script")
               (:file "chess")))

