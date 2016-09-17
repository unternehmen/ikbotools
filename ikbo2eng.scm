#! /bin/sh
# -*- scheme -*-
exec /usr/bin/env guile-2.0 -l "$0" "$@"
!#

(define (translate-word str)
  ; Convert the word in `str` into ikbo.
  )

; translate-text :: String -> String
(define (translate-text str)
  ; Split `str` into runs of text:
  ;   1. which need to be translated
  ;   2. which ought to be retained as they are
  ; and map through translate-word.
  ; Map selectively through translate-word and then flatten again into
  ; one string.
  )
