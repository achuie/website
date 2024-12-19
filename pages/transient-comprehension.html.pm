#lang pollen

◊(require racket/string
          racket/system
          racket/port
          racket/list
          racket/path
          racket/date
          pollen/core)

◊h1{Project SPINLOCK}

\\

◊h4{Posts}

◊(define post-links (map (λ (path) `(a ((href ,(string-trim (path-element->string path) ".pm"))) (select 'h1 path)))
       (sort (filter (λ (name) (define ext (path-get-extension name)) (and ext (bytes=? ext #".pm")))
                     (directory-list (build-path ".." "posts")))
             >
             #:key (λ (post)
                     (define published (select-from-metas 'published (get-metas (build-path ".." "posts" post))))
                     (define seconds (if published
                                       (apply
                                         find-seconds
                                         (append (list 0 0 0)
                                                 (map (λ (s) (string->number s))
                                                      (string-split published))
                                                 (list #f)))
                                       #f))
                     (if seconds seconds 0)))))

◊ul{◊(@ (map (λ (link) `(li ,link)) post-links))}
