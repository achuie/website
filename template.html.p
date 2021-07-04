<html>
<head>
  <meta charset="UTF-8">
  ◊(define title (select 'h1 doc))
  <title>◊(if title title "Home") &ndash; AH</title>
  <link rel="stylesheet" type="text/css" media="all" href="style.css" />
</head>
◊(define (body-with-nav)
  ◊body{
    ◊div[#:class "content"]{
      ◊div[#:class "navbar-cell"]{
        ◊div[#:class "navbar"]{
          ◊img[#:style "width: 6vmax; margin-top: 2.15em" #:src "images/columns.jpg" #:alt "Icon"]{} ◊br{}
          ◊nav-link["index.html"]{Home} ◊br{}
          ◊nav-link["about.html"]{About} ◊br{}
          ◊nav-link[
            "https://github.com/achuie/resume/blob/master/andrew_huie.pdf"]{Resume} ◊br{}
          ◊nav-link["interests.html"]{Interests}
        }
      }
      ◊div[#:class "main-cell"]{ ◊div[#:class "main"]{◊doc} }
    }
  })
◊(->html (body (body-with-nav)) #:splice? #t)
</html>
