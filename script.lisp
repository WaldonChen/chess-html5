;;;; script.lisp

(in-package #:chess)


;;; Game Logic
(defun main-js ()
  (setf (content-type*) "text/javascript")
  (ps
    (chain
      ($ document)
      (ready
        (lambda ()
          (let ((canvas (chain ($ "#canvas") 0))
                (context (chain ($ "#canvas") 0 (get-context "2d")))
                (chess (create topleft (create x 0 y 0)
                               size (create width 0 height 0)
                               border-width 1
                               padding 20
                               outer-width 7)))
            (chain ($ "#canvas")
                   (on "click"
                       (lambda (event)

                         )))
            (defmacro draw-chess-man (party role x y)
              `(let ((chess-man (new (-image)))
                     (size (* 1/12 (chain chess size height))))
                 (progn
                   (chain chess-man
                          (add-event-listener
                            "load"
                            (lambda ()
                              (chain context
                                     (draw-image
                                       chess-man
                                       (- (pt-to-pos-x ,x) (* 0.5 size))
                                       (- (pt-to-pos-y ,y) (* 0.5 size))
                                       size size)))
                            false))
                   (chain chess-man (add-event-listener
                                      "clicked"
                                      (lambda ()
                                        (alert "foo"))
                                      false))
                   (setf (@ chess-man src)
                         ,(format nil "chess-man?party=~A&role=~A"
                                  (string party)
                                  (string role))))))

            (defun fill-circle (x y radius &optional &key
                                  (style "yellow"))
              (setf (@ context fill-style) style)
              (chain context (begin-path))
              (chain context (arc x y radius 0 (* (chain -math -p-i) 2) 'true))
              (chain context (close-path))
              (chain context (fill)))

            (defmacro pt-to-pos-x (pt)
              `(+ (@ chess topleft x)
                  (* (/ ,pt 8) (@ chess size width))))

            (defmacro pt-to-pos-y (pt)
              `(+ (@ chess topleft y)
                  (* (/ ,pt 9) (@ chess size height))))

            (defmacro draw-text-on-chess (text x y &rest rest-args)
              `(funcall #'fill-text ,text (pt-to-pos-x ,x)
                        (pt-to-pos-y ,y) ,@rest-args))

            (defmacro draw-line-on-chess (x y x2 y2 &rest rest-args)
              `(funcall #'stroke-line (pt-to-pos-x ,x) (pt-to-pos-y ,y)
                        (pt-to-pos-x ,x2) (pt-to-pos-y ,y2) ,@rest-args))

            (defun stroke-line (start-x start-y end-x end-y &optional &key
                                        (style "black")
                                        (line-width 1))
              (setf (@ context fill-style) style
                    (@ context line-width) line-width)
              (chain context (begin-path))
              (chain context (move-to start-x start-y))
              (chain context (line-to end-x end-y))
              (chain context (stroke))
              (chain context (close-path)))

            (defun stroke-rect (x y width height &optional &key
                                  (style "black")
                                  (line-width 1))
              (setf (@ context fill-style) style
                    (@ context line-width) line-width)
              (chain context (stroke-rect (+ x (/ line-width 2))
                                          (+ y (/ line-width 2))
                                          (- width line-width)
                                          (- height line-width))))

            (defun fill-text (text x-pos y-pos &optional &key
                                    (fill-style "black")
                                    (font "32px Sans-Serif"))
              (setf (@ context fill-style) fill-style
                    (@ context font) font
                    (@ context text-baseline) "middle"
                    (@ context text-align) "center")
              (chain context (fill-text text x-pos y-pos)))

            (defun draw-chess ()
              (let ((x (@ chess topleft x))
                    (y (@ chess topleft y))
                    (width (@ chess size width))
                    (height (@ chess size height))
                    (out-border (@ chess outer-width)))
              ; Draw the outer rectangle of chess
              (stroke-rect (- x out-border) (- y out-border)
                           (+ width (* 2 out-border)) (+ height (* 2 out-border))
                           :line-width 5)
              (stroke-rect x y width height
                           :line-width 1)
              ; Horizontal line
              (loop for i from 1 to 8 do
                      (draw-line-on-chess 0 i 8 i))
              ; Vertical lines
              (loop for i from 1 to 7 do
                    (draw-line-on-chess i 0 i 4)
                    (draw-line-on-chess i 5 i 9))
              (draw-line-on-chess 3 0 5 2)
              (draw-line-on-chess 3 7 5 9)
              (draw-line-on-chess 5 0 3 2)
              (draw-line-on-chess 5 7 3 9)
              (draw-text-on-chess "界" 2.5 4.5
                                 :font (+ (/ width 12) "px Sans-Serif"))
              (draw-text-on-chess "河" 5.5 4.5
                                 :font (+ (/ width 12) "px Sans-Serif")))
              )

            (defun draw-screen ()
              (let* ((border-height (min (@ canvas width) (@ canvas height)))
                     (border-width (* border-height 0.9))
                     (border-x (* (- (@ canvas width) border-width) 0.5))
                     (border-y 0)
                     (padding (@ chess padding)))
                ; draw border of chess
                (stroke-rect border-x 0
                             border-width border-height)
                (setf (@ chess topleft x) (+ padding border-x)
                      (@ chess topleft y) (+ padding border-y)
                      (@ chess size width) (- border-width (* padding 2))
                      (@ chess size height) (- border-height (* padding 2)))
                (draw-chess)
                (draw-chess-man :red :king  2 3)
                (draw-chess-man :red :king  2 4)
                (draw-chess-man :red :king  1 4)
                ))

            (setf (@ canvas width) (- (chain window inner-width) 20)
                  (@ canvas height) (- (chain window inner-height) 20))
            (draw-screen)
            ))))))

