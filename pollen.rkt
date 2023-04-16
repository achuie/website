#lang racket/base

(require racket/string
         pollen/decode 
         pollen/unstable/typography
         txexpr)

(module setup racket/base
  (require pollen/setup)

  (provide (all-defined-out))
  (define block-tags (append '(img) default-block-tags)))

(provide (all-defined-out))

(define (nav-link url text) `(a ((class "navlink") (href ,url)) ,text))

(define (body-link url text) `(a ((class "bodylink") (href ,url)) ,text))

;; Find photos and generate image tags for each.
(define list-photos
  (map (λ (path)
          `(img ((src ,(path->string (build-path
                          "https://media.githubusercontent.com/media/achuie/achuie.github.io/master/images/thumbnails"
                          path)))
                 (width "100%")
                 (class "masonry-img"))))
       (directory-list (build-path (current-directory) "images" "thumbnails"))))

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
                     #:txexpr-elements-proc smart-paragraphs))
  (list* 'div '((id "doc"))
         (decode-elements processed-elems
                          #:string-proc smart-and-trim)))
