◊(require txexpr)

◊(define is-display-image? (λ (x) (and (and (txexpr? x) (eq? 'img (get-tag x)))
                                       (member '(id "fillIn") (get-attrs x)))))
◊(define navbar
  ◊div[#:class "my-navbar"]{
    ◊img[#:style "width: 6vmax; vertical-align: middle;"
         #:src "https://media.githubusercontent.com/media/achuie/achuie.github.io/master/images/columns.jpg"
         #:alt "Icon"]{} ◊br{}
    ◊nav-link["index.html"]{home} ◊br{}
    ◊nav-link["about.html"]{about} ◊br{}
    ◊nav-link["interests.html"]{interests}
  })
◊(define back-button
  ◊div[#:class "backbutton"]{◊a[#:class "backbutton-link" #:href "photography.html"]{←}})
◊(define body-with-nav
  ◊body{
    ◊div[#:class "wrapper"]{
      ◊;; Bulma class content.
      ◊div[#:class "content columns"]{
        ◊div[#:class "column is-one-fifth"]{
          ◊(if (findf-txexpr doc is-display-image?)
               back-button
               navbar)
        }
        ◊div[#:class "column"]{
          ◊div[#:class "main"]{◊doc}
        }
      }
      ◊footer[#:class "footer"]{
        ◊div[#:class "content"]{
          ◊body-link-external["https://github.com/achuie"]{GitHub}
          ◊body-link-external["https://www.instagram.com/achooie42"]{Instagram} ◊br{}
          Made with
          ◊body-link-external["https://git.matthewbutterick.com/mbutterick/pollen"]{Pollen}
          and
          ◊body-link-external["https://bulma.io"]{Bulma}
        }
      }
    }
  })

<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  ◊(define title (select 'h1 doc))
  <title>◊(if title title "Home") &ndash; AH</title>
  <link rel="shortcut icon" type="image/jpg" href="https://media.githubusercontent.com/media/achuie/achuie.github.io/master/images/columns.jpg"/>
  <link rel="stylesheet" type="text/css" media="all" href="style.css"/>
</head>
◊(->html body-with-nav #:splice? #t)
</html>
