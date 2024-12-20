#lang pollen

◊(require racket/string
          racket/system
          racket/port
          racket/list)

◊;; Extract a photo's `DateTimeOriginal` exif data as a string of digits.
◊(define (get-photo-datestring photo-path)
         (define exif-out
           (with-output-to-string (λ () (system (format "exif -dt DateTimeOriginal ~a" photo-path)))))
         (define grep-out
           (with-output-to-string (λ () (with-input-from-string exif-out (λ () (system "grep Value"))))))
         (define sed-out
           (with-output-to-string
             (λ () (with-input-from-string exif-out (λ () (system "sed 's/[a-zA-Z: ]*//g'"))))))
         (last (string-split sed-out "\n")))

◊;; Find photos and generate image tags for each.
◊(define list-photos
         (map
           (λ (path)
             `(a
                ((href ,(string-append "image_display.html?Viewing_Image=" (path-element->string path))))
                (img
                  ((src
                     ,(path->string
                        (build-path
                          "https://media.githubusercontent.com/media/achuie/achuie.github.io/master/images/thumbnails"
                          path)))
                   (width "100%")
                   (class "masonry-img")))))
           ; Sort in reverse-chronological order.
           (sort (directory-list (build-path ".." "images" "thumbnails"))
                 string>?
                 #:key (λ (pic) (get-photo-datestring (build-path ".." "images" "portfolio" pic))))))

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
