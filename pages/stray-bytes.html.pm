#lang pollen

◊(require racket/string
          racket/system
          racket/port
          racket/list
          racket/path
          racket/date)

◊(define (get-published-timestamp pollen-srcfile)
         (define published (select-from-metas 'published (get-metas (build-path posts-path pollen-srcfile))))
         (define seconds
           (if published
             (published->timestamp published)
             #f))
         (if seconds seconds 0))
◊(define posts-path (build-path ".." "posts"))
◊(define post-links
         (map (λ (sorted-pollen-srcfile)
                (define path-to-srcfile (build-path posts-path sorted-pollen-srcfile))
                (define srcfile-published-ts (get-published-timestamp sorted-pollen-srcfile))
                `(p (span ((class "blog-list-date")) ,(seconds->default-datestring srcfile-published-ts 'iso-8601))
                    ; En space u2002
                    " "
                    (a ((class "bodylink")
                        (title ,(seconds->default-datestring srcfile-published-ts 'american))
                        (href ,(string-trim (path->string path-to-srcfile) ".pm")))
                       ,(select 'h1 path-to-srcfile))))
              (sort (filter (λ (name)
                              (define ext (path-get-extension name))
                              (and ext (bytes=? ext #".pm")))
                            (directory-list (build-path posts-path)))
                    >
                    #:key get-published-timestamp)))

◊h1{Stray Bytes}

\\

◊h4{Posts}

◊`(ul ,@(map (λ (link) `(li ,link)) post-links))
