#! /bin/sh
# -*- scheme -*-
exec /usr/bin/env guile-2.0 -l "$0" "$@"
!#
(use-modules (ice-9 regex))

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

(define special-words
  '(("ang" . "the")
    ("Ang" . "The")
    ("ikabo" . "a/n")
    ("Ikabo" . "A/n")
    ("iktbo" . "to")
    ("Iktbo" . "To")
    ("biz" . "without")
    ("Biz" . "Without")
    ("bik" . "bye")
    ("Bik" . "Bye")
    ("bik'bos" . "goodbye")
    ("Bik'bos" . "Goodbye")))

; translate-word :: String -> String
(define (translate-word str)
  (let ((gloss (assoc-ref special-words str)))
    (if (eq? #f gloss)
      (->>
        str
        (decode-prefix)
        (decode-suffix)
        (string-map decode-vowel))
      gloss)))

; The folowing function could be used for translating a list of runs.

; synthesize-runs :: [(Bool . String)] -> String
(define (synthesize-runs runs)
  (apply string-append
    (map
      (lambda (run)
        (if (car run)
          (translate-word (cdr run))
          (cdr run)))
      runs)))

; bug - replace below algorithm by an iterative one?

; break-by-wordness :: String -> [(Bool . String)]
(define (break-by-wordness str)
  (define (is-word? c)
    (or (char-alphabetic? c)
        (char=? c #\')))
  (define (string-index-or-all str pred?)
    (let ((result (string-index str pred?)))
      (if (eq? #f result)
        (string-length str)
        result)))
  (if (string-null? str)
    '()
    (if (is-word? (string-ref str 0))
      (let ((index (string-index-or-all str (negate is-word?))))
        (cons (cons #t (substring str 0 index))
              (break-by-wordness (string-drop str index))))
      (let ((index (string-index-or-all str is-word?)))
        (cons (cons #f (substring str 0 index))
              (break-by-wordness (string-drop str index)))))))

; translate-text :: String -> String
(define (translate-text str)
  (synthesize-runs (break-by-wordness str)))
