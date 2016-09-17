#! /bin/sh
# -*- scheme -*-
exec /usr/bin/env guile-2.0 -l "$0" "$@"
!#

(define-syntax ->>
  (syntax-rules ()
    ((->> a (f xs ...) rest ...)
     (->> (f xs ... a) rest ...))
    ((->> a)
     a)))

; decode-vowel :: Character -> Character
(define (decode-vowel c)
  (cond ((char=? c #\a) #\u)
        ((char=? c #\e) #\a)
        ((char=? c #\i) #\e)
        ((char=? c #\o) #\i)
        ((char=? c #\u) #\o)
        ((char=? c #\A) #\U)
        ((char=? c #\E) #\A)
        ((char=? c #\I) #\E)
        ((char=? c #\O) #\I)
        ((char=? c #\U) #\O)
        (else c)))

; decode-prefix :: String -> String
(define (decode-prefix str)
  (let ((match (string-match "^([aeiouAEIOU])k" str)))
    (if (eq? #f match)
      (let ((match (string-match "^(.)ik" str)))
        (if (eq? #f match)
          str
          (string-append
            (string-take str 1)
            (string-drop str 3))))
      (string-append
        (string-take str 1)
        (string-drop str 2)))))

; decode-suffix :: String -> String
(define (decode-suffix str)
  (let ((match (string-match "bo(.)$" str)))
    (if (eq? #f match)
      str
      (string-append
        (string-take str (- (string-length str) 3))
        (string-drop str (- (string-length str) 1))))))

; translate-word :: String -> String
(define (translate-word str)
  (->>
    str
    (decode-prefix)
    (decode-suffix)
    (string-map decode-vowel)))

#!
; translate-text :: String -> String
(define (translate-text str)
  (string-fold (lambda (c acc) ) '() s)
  ; Split `str` into runs of text:
  ;   1. which need to be translated
  ;   2. which ought to be retained as they are
  ; and map through translate-word.
  ; Map selectively through translate-word and then flatten again into
  ; one string.
  )
!#
