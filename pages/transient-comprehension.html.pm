#lang pollen

◊(require racket/string
          racket/system
          racket/port
          racket/list
          racket/path
          racket/date)

◊h1{Transient Comprehension}

\\

◊h4{Posts}

◊(map (λ (path) `(a ((href ,(path-element->string path))) (select 'h1 path)))
      (sort (filter (λ (name) (define ext (path-get-extension name)) (and ext (bytes=? ext #".pm")))
                    (directory-list (build-path ".." "posts")))
            >
            #:key (λ (post) (define seconds (select-from-metas
                                                              'published
                                                              (get-metas (build-path ".." "posts" post))))
                    (if seconds (string->number seconds) 0))))
