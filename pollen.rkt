#lang racket/base

(require racket/string
         racket/date
         pollen/core
         pollen/decode 
         pollen/unstable/typography
         pollen/tag
         txexpr)

(module setup racket/base
  (require pollen/setup)

  (provide current-project-root)
  (provide (all-defined-out))
  (define block-tags (append '(img script code-block) default-block-tags)))

(require 'setup)

(provide (all-defined-out))

(define (nav-link url text) `(a ((class "navlink") (href ,url)) ,text))

(define (body-link url text) `(a ((class "bodylink") (href ,url)) ,text))

(define-tag-function (code-block attrs elems) `(pre ,attrs (code ,@elems)))

(define (published->timestamp published-string)
  (apply
    find-seconds
    (append (list 0 0 0) (map (λ (s) (string->number s)) (string-split published-string)) (list #f))))

(define (seconds->default-datestring timestamp string-format)
  (if (> timestamp 0)
      (parameterize ([date-display-format string-format])
        (date->string (seconds->date timestamp)))
      "(unpublished)"))

(define (post-title title)
  (define published (select-from-metas 'published (current-metas)))
  (define seconds (if published (published->timestamp published) #f))
  `(h1 ((class "post-title"))
       ,title
       (span ((class "post-date")) ,(seconds->default-datestring seconds 'iso-8601))))

(define (subheading level title)
  (define title-id (string-join (string-split title) "-"))
  `(,level ((id ,title-id) (class "linkable-heading")) (a ((class "subheadinglink") (href ,(string-append "#" title-id))) "#") ,title))

;; Only convert a newline to a linebreak if the preceding line ends with "\\".
(define (latex-linebreaker prev next)
  (if (and (string? prev) (regexp-match #rx"\\\\$" prev))
      '(br)
      " "))

;; All the smart features plus trim ending "\\".
(define smart-and-trim
  (compose1 smart-quotes smart-dashes smart-ellipses (λ (s) (string-trim s "\\\\"))))

;; Decode paragraphs plus LaTeX-style linebreaks.
(define (smart-paragraphs elements)
  (define (decode-latex-lines elements)
    (decode-linebreaks elements latex-linebreaker))
  (decode-paragraphs elements #:linebreak-proc decode-latex-lines))

(define (root . elements)
  (define processed-elems
    (decode-elements elements
                     #:txexpr-elements-proc smart-paragraphs
                     #:exclude-tags block-tags))
  ; Bulma.css requires class container inside a column to render elements full-width instead of
  ; auto-shrinking to fit.
  (list* 'div '((id "doc") (class "container"))
         (decode-elements processed-elems
                          #:string-proc smart-and-trim
                          #:exclude-tags (list 'pre 'code))))
