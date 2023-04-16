#lang pollen

◊(define photos list-photos)
◊(define (one-third-panel-content idx)
  `(div ((class "masonry-panel__content"))
        ,@(for/list
            ([i (in-range idx (length photos) 3)])
            (list-ref photos i))))

◊h1{Photography}

\\

◊div[#:class "masonry-layout"]{
  ◊div[#:class "masonry-panel"]{
    ◊(one-third-panel-content 0)
  }
  ◊div[#:class "masonry-panel"]{
    ◊(one-third-panel-content 1)
  }
  ◊div[#:class "masonry-panel"]{
    ◊(one-third-panel-content 2)
  }
}
