#lang pollen

◊body{
  ◊div[#:class "content"]{
    ◊div[#:class "navbar-cell"]{
      ◊a[#:class "back-button" #:href "photography.html"]{ ← }
    }
    ◊div[#:class "main-cell"]{
      ◊div[#:class "main"]{
        ◊img[#:id "fillIn" #:style "width: 100%; height:100%"
             #:src ""
             #:alt ""]{}
      }
    }
  }
}

◊script[#:type "text/javascript" #:src "fill_image.js"]{}
