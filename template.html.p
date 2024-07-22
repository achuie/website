◊(require txexpr)

◊;; Deal with subdirectories.
◊(define path-prefix (if (string-contains? (symbol->string here) "/") "../" ""))
◊;; Determine whether current page is the image display page.
◊(define is-display-image? (λ (x) (and (and (txexpr? x) (eq? 'img (get-tag x)))
                                       (member '(id "fillIn") (get-attrs x)))))
◊(define navbar
  ◊div[#:class "my-navbar"]{
    ◊img[#:style "width: 6vmax; vertical-align: middle;"
         #:src "https://media.githubusercontent.com/media/achuie/achuie.github.io/master/images/columns.jpg"
         #:alt "Icon"]{} ◊br{}
    ◊nav-link[(string-append path-prefix "index.html")]{home} ◊br{}
    ◊nav-link[(string-append path-prefix "pages/transient-comprehension.html")]{"blog"} ◊br{}
    ◊nav-link[(string-append path-prefix "pages/interests.html")]{interests}})
◊(define back-button
  ◊div[#:class "backbutton"]{◊a[#:class "backbutton-link"
                                #:href (string-append path-prefix "pages/photography.html")]{←}})
◊(define body-with-sidebar
  ◊body{
    ◊div[#:class "wrapper"]{
      ◊; Bulma class content.
      ◊div[#:class "content columns"]{
        ◊div[#:class "column is-one-fifth"]{
          ◊(if (findf-txexpr doc is-display-image?)
               back-button
               navbar)}
        ◊div[#:class "column"]{◊div[#:class "main"]{◊doc}}}
      ◊footer[#:class "footer"]{
        ◊div[#:class "content"]{
          ◊span[#:class "footer-separator"]{𝄽} ◊br{} ◊br{}
          ◊body-link["https://github.com/achuie"]{GitHub}
          ◊body-link["https://www.instagram.com/achooie42"]{Instagram}
          ◊body-link[(string-append path-prefix "pages/about.html")]{About} ◊br{}
          Made with
          ◊body-link["https://git.matthewbutterick.com/mbutterick/pollen"]{Pollen} and
          ◊body-link["https://bulma.io"]{Bulma}}}}})

<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  ◊(define title (select 'h1 doc))
  <title>◊(if title title "Home") &ndash; AH</title>
  <link rel="shortcut icon" type="image/jpg" href="https://media.githubusercontent.com/media/achuie/achuie.github.io/master/images/columns.jpg"/>
  <link rel="stylesheet" type="text/css" media="all" href="◊|path-prefix|css/style.css"/>
</head>
◊(->html body-with-sidebar #:splice? #t)
</html>
