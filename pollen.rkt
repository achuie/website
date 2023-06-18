#lang racket/base

(require racket/string
         pollen/decode 
         pollen/unstable/typography
         txexpr)

(module setup racket/base
  (require pollen/setup)

  (provide (all-defined-out))
  (define block-tags (append '(img script) default-block-tags)))

(provide (all-defined-out))

(define (nav-link url text) `(a ((class "navlink") (href ,url)) ,text))

(define (body-link url text) `(a ((class "bodylink") (href ,url)) ,text))

;; body-link styling with an "external link" symbol svg.
;; viewBox: 0--16 square
(define (body-link-external url text)
  `(a ((class "bodylink")
       (href ,url)
       (style "white-space: pre"))
      ,text
      (svg ((xmlns "http://www.w3.org/2000/svg") (viewBox "-3 0 19 18") (width "0.4rem") (height "0.4rem") (fill "currentColor"))(path ((fill-rule "evenodd") (d "M8.636 3.5a.5.5 0 0 0-.5-.5H1.5A1.5 1.5 0 0 0 0 4.5v10A1.5 1.5 0 0 0 1.5 16h10a1.5 1.5 0 0 0 1.5-1.5V7.864a.5.5 0 0 0-1 0V14.5a.5.5 0 0 1-.5.5h-10a.5.5 0 0 1-.5-.5v-10a.5.5 0 0 1 .5-.5h6.636a.5.5 0 0 0 .5-.5z"))) (path ((fill-rule "evenodd") (d "M16 .5a.5.5 0 0 0-.5-.5h-5a.5.5 0 0 0 0 1h3.793L6.146 9.146a.5.5 0 1 0 .708.708L15 1.707V5.5a.5.5 0 0 0 1 0v-5z"))))))

;; Find photos and generate image tags for each.
(define list-photos
  (map (λ (path)
          `(a ((href ,(string-append "image_display.html?Viewing_Image=" (path-element->string path))))
              (img ((src ,(path->string (build-path
                                          "https://media.githubusercontent.com/media/achuie/achuie.github.io/master/images/thumbnails"
                                          path)))
                    (width "100%")
                    (class "masonry-img")))))
       (directory-list
         (build-path (current-directory) "images"
                     "thumbnails"))))

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
  ;; Bulma.css requires class container inside a column to render elements full-width instead of
  ;; auto-shrinking to fit.
  (list* 'div '((id "doc") (class "container"))
         (decode-elements processed-elems
                          #:string-proc smart-and-trim)))
