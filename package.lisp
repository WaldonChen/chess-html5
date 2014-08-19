;;;; package.lisp

(defpackage :chess
  (:use :common-lisp
        :cl-who
        :hunchentoot
        :parenscript)
  (:export :start-server
           :stop-server))

