#lang pollen

◊(require racket/string
          racket/system
          racket/port
          racket/list
          racket/file)

◊;; Find photos and generate image tags for each.
◊(define list-photos
   (map
    (λ (pair)
      (define path (car pair))
      `(a ((href ,(string-append "image_display.html?Viewing_Image=" path)))
          (img ((src ,(path->string (build-path ".." "images" "thumbnails" path)))
                (width "100%")
                (class "masonry-img")))))
    ; Sort in reverse-chronological order.
    (sort
     (map (λ (name timestamp) (cons name timestamp))
          (file->lines (build-path ".." "portfolio_files.txt"))
          (file->lines (build-path ".." "portfolio_datetimes.txt")))
          string>?
          #:key (λ (pair) (cdr pair)))))

◊(define photos list-photos)
◊(define (one-half-panel-content idx)
   `(div ((class "masonry-panel__content"))
         ,@(for/list ([i (in-range idx (length photos) 2)])
             (list-ref photos i))))

◊h1{Photography}

\\

◊div[#:class "masonry-layout"]{
  ◊div[#:class "masonry-panel"]{
    ◊(one-half-panel-content 0)
  }
  ◊div[#:class "masonry-panel"]{
    ◊(one-half-panel-content 1)
  }
}
