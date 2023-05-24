◊(require txexpr)

◊(define is-display-image? (λ (x) (and (and (txexpr? x) (eq? 'img (get-tag x)))
                                       (member '(id "fillIn") (get-attrs x)))))
◊(define navbar
   ◊div[#:class "navbar"]{
    ◊img[#:style "width: 5vmax; vertical-align: middle;"
         #:src "https://media.githubusercontent.com/media/achuie/achuie.github.io/master/images/columns.jpg"
         #:alt "Icon"]{} ◊br{}
    ◊nav-link["index.html"]{Home} ◊br{}
    ◊nav-link["about.html"]{About} ◊br{}
    ◊nav-link[
      "https://raw.githubusercontent.com/achuie/resume/master/andrew_huie.pdf"]{Resume} ◊br{}
    ◊nav-link["interests.html"]{Interests}
  })
◊(define back-button
  ◊div[#:class "navbar"]{◊a[#:class "back-button" #:href "photography.html"]{←}})
◊(define body-with-nav
  ◊body{
    ◊div[#:class "content"]{
      ◊div[#:class "navbar-cell"]{
        ◊(if (findf-txexpr doc is-display-image?)
            back-button
            navbar)
      }
      ◊div[#:class "main-cell"]{ ◊div[#:class "main"]{◊doc} }
    }
  })

<html>
<head>
  <meta charset="UTF-8">
  ◊(define title (select 'h1 doc))
  <title>◊(if title title "Home") &ndash; AH</title>
  <link rel="shortcut icon" type="image/jpg" href="https://media.githubusercontent.com/media/achuie/achuie.github.io/master/images/columns.jpg"/>
  <link rel="stylesheet" type="text/css" media="all" href="style.css"/>
</head>
◊(->html body-with-nav #:splice? #t)
</html>
