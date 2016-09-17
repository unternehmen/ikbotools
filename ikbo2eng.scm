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

#! These parts are currently not in a working state.

; break-into-runs :: String -> [(Bool . String)]
(define (break-into-runs str)
  (define (iter in-word? current acc)
    (if in-word?
      (if (char-alphabetic? c)
        (iter in-word? (cons c current) acc)
        (iter (not in-word?)
              '()
              (cons
                (apply string (reverse current))
                acc)))
      (if (char-alphabetic? c)
        (iter (not in-word?)
              '()

; break-by-words :: String -> [String]
(define (break-by-words str)
  (let* ((start (string-index str word-char?))
         (end   (string-index str (negate word-char?) start))
         (word  (substring str start end)))
    (if (= start 0)
      ; The whole next chunk is a word.  Read it.
      (cons 
      ; The whole next chunk is non-word followed by a word.
          (substring str
            (string-index str word-char?)
            (string-index str (negate word-char?)))))

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
