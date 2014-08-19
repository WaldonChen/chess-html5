;;;; chess.lisp

(in-package #:chess)

(setf (cl-who:html-mode) :html5)

(defmacro standard-page ((&key title) &body body)
  `(with-html-output-to-string
     (*standard-output* nil :prologue t :indent t)
     (:html :lang "en"
      (:head
        (:meta :charset "utf-8")
        (:title ,title)
        (:script :type "text/javascript"
         :src "js/jquery.js")
        (:script :type "text/javascript"
         :src "js/chess-man.js")
        (:script :type "text/javascript"
         :src "js/main.js"))
      (:body
        ,@body))))

(defun home-page ()
  (standard-page
    (:title "Hello")
    (:canvas

      :id "canvas"
      "Your browser does not support HTML5 Canvas.")))

(defun make-keyword (name)
  (values (intern (string-upcase name) "KEYWORD")))

(defun get-chess-man ()
  (setf (content-type*) "image/svg+xml")
  (let ((party (get-parameter "party"))
        (role (get-parameter "role")))
    (chess-man (make-keyword party) (make-keyword role))))

(setq hunchentoot:*dispatch-table*
      (nconc
        (list 'hunchentoot:dispatch-easy-handlers
              (hunchentoot:create-folder-dispatcher-and-handler
                "/img/"
                "static/img/")
              (hunchentoot:create-static-file-dispatcher-and-handler
                "/js/jquery.js"
                "static/js/jquery.1.9.1.min.js")
              (hunchentoot:create-static-file-dispatcher-and-handler
                "/js/chess-man.js"
                "static/js/chess-man.js"))
        (mapcar (lambda (args)
                  (apply 'hunchentoot:create-prefix-dispatcher args))
                '(("/chess-man" get-chess-man)
                  ("/js/main.js" main-js)
                  ("/" home-page)))))

(let ((*http-server*
        (make-instance 'hunchentoot:easy-acceptor :port 8080)))
  (defun start-server ()
    (hunchentoot:start *http-server*))
  (defun stop-server ()
    (hunchentoot:stop *http-server*)))
