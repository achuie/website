#lang pollen

◊(define photos list-photos)

◊h1{Photography}

\\

◊div[#:class "masonry-layout"]{
  ◊div[#:class "masonry-panel"]{
    ◊`(div ((class "masonry-panel__content")) ,@(for/list
      ([i (in-range 0 (length photos) 3)])
      (list-ref photos i)))
  }
  ◊div[#:class "masonry-panel"]{
    ◊`(div ((class "masonry-panel__content")) ,@(for/list
      ([i (in-range 1 (length photos) 3)])
      (list-ref photos i)))
  }
  ◊div[#:class "masonry-panel"]{
    ◊`(div ((class "masonry-panel__content")) ,@(for/list
      ([i (in-range 2 (length photos) 3)])
      (list-ref photos i)))
  }
}
