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
          ◊nav-link["index.html"]{Home} ◊br{}
          ◊nav-link["pages/about.html"]{About} ◊br{}
          ◊nav-link["pages/resume.html"]{Resume} ◊br{}
        }
      }
      ◊div[#:class "main-cell"]{ ◊div[#:class "main"]{◊doc} }
    }
  })
◊(->html (body (body-with-nav)) #:splice? #t)
</html>
