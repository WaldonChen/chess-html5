(in-package #:chess)

;; role => :KING :QUEEN :BISHOP :KNIGHT :ROOK :CANNON :PAWN
;; party => :RED :BLACK
(defmacro if-party (red black)
  `(case party
     (:RED ,red)
     (:BLACK ,black)
     (otherwise nil)))

(defun role-string (party role)
  (case role
    (:KING (if-party "帥" "將"))
    (:QUEEN (if-party "仕" "士"))
    (:BISHOP (if-party "相" "象"))
    (:KNIGHT (if-party "俥" "車"))
    (:ROOK (if-party "傌" "馬"))
    (:CANNON (if-party "炮" "砲"))
    (:PAWN (if-party "兵" "卒"))
    (otherwise nil)))

(defun chess-man (party role)
  (let ((scene (svg:make-svg-toplevel
                  'svg:svg-1.1-toplevel
                  :height 256 :width 256
                  :pointer-events "none"
                  ; :transform (format nil "scale(~D)" (/ size 256.0))
                  )))
    (svg:draw scene
              (:circle :cx "50%" :cy "50%"
               :r "50%")
              :stroke "rgba(0, 0, 0, 0)"
              :fill "rgb(196, 188, 52)")
    (svg:draw scene
              (:circle :cx "50%" :cy "50%"
               :r "43%")
              :stroke "rgb(0, 0, 0)"
              :stroke-width 8
              :fill "rgba(0, 0, 0, 0)")
    (svg:text scene
              (:x "50%" :y "50%" :dy "0.1em" :font-size "160px"
               :text-anchor "middle" :dominant-baseline "middle")
              (role-string party role))
    (with-output-to-string
      (s) (svg:stream-out s scene))))

(defmacro chess-man-to-file (&rest rest)
  (let ((file-name (concatenate 'string (string (car rest))
                                "-" (string (cadr rest))
                                ".svg")))
    `(with-open-file (s ,file-name
                        :direction :output :if-exists :supersede)
       (format s (funcall #'chess-man ,@rest)))))

; (with-open-file
      ; (s #p"test.svg" :direction :output :if-exists :supersede)
      ; (svg:stream-out s scene))
