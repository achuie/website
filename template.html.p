◊(require txexpr
          racket/path
          pollen/setup)

◊;; Deal with subdirectories.
◊(define path-prefix (if (regexp-match #rx"^[a-zA-Z0-9]+/" (symbol->string here)) "../" ""))

◊;; Determine whether current page is the image display page.
◊(define is-display-image? (λ (x) (and (and (txexpr? x) (eq? 'img (get-tag x)))
                                       (member '(id "fillIn") (get-attrs x)))))
◊(define navbar
  ◊div[#:class "my-navbar"]{
    ◊img[#:style "width: 6vmax; vertical-align: middle;"
         #:src (string-append path-prefix "images/columns.jpg")
         #:alt "Icon"]{} ◊br{}
    ◊nav-link[(string-append path-prefix "index.html")]{home} ◊br{}
    ◊nav-link[(string-append path-prefix "pages/stray-bytes.html")]{"blog"} ◊br{}
    ◊nav-link[(string-append path-prefix "pages/photography.html")]{photography}})
◊(define back-button
  ◊div[#:class "backbutton"]{◊a[#:class "backbutton-link"
                                ◊; u2190
                                #:href (string-append path-prefix "pages/photography.html")]{←}})
◊(define body-with-sidebar
  ◊body{
    ◊div[#:class "wrapper"]{
      ◊div[#:class "toggle-wrapper"]{
        ◊; u25d1
        ◊span[#:class "toggle-label"]{◑}
        ◊input[#:type "checkbox" #:id "theme-toggle"]{}
        ◊label[#:for "theme-toggle" #:class "theme-switch"]{
          ◊svg[#:viewBox "0 0 50 30" #:xmlns "http://www.w3.org/2000/svg"]{
            ◊rect[#:class "toggle-bg" #:x "1" #:y "1" #:width "48" #:height "28" #:rx "14"]{}
            ◊circle[#:class "toggle-thumb" #:cx "15" #:cy "15" #:r "12"]{}
          }
        }
      }
      ◊; Bulma class content.
      ◊div[#:class "content columns"]{
        ◊div[#:class "column is-one-fifth"]{
          ◊(if (findf-txexpr doc is-display-image?)
               back-button
               navbar)}
        ◊div[#:class "column"]{◊div[#:class "main"]{◊doc}}}
      ◊footer[#:class "footer"]{
        ◊div[#:class "content"]{
          ◊; Creative-heaven wanderer receptive-earth
          ◊span[#:class "footer-separator"]{䷁ ䷷ ䷀} ◊br{} ◊br{}
          ◊body-link["https://github.com/achuie"]{GitHub}
          ◊body-link["https://www.instagram.com/achooie42"]{Instagram}
          ◊body-link[(string-append path-prefix "pages/about.html")]{About} ◊br{}
          Made with
          ◊body-link["https://git.matthewbutterick.com/mbutterick/pollen"]{Pollen} and
          ◊body-link["https://bulma.io"]{Bulma}}}
      ◊script[#:type "text/javascript" #:src (string-append path-prefix "js/dark_mode.js")]{}
    }
  }
)

<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  ◊(define title (select 'h1 doc))
  <title>◊(if title title "Home") &ndash; AH</title>
  ◊; Prevent flashbang by running JS to set color theme before css loads
  <script>
    (function() {
      const theme = new URLSearchParams(location.search).get('theme');
      if (theme === 'dark' || theme === 'light') {
        document.documentElement.setAttribute('data-theme', theme);
      }
    })();
  </script>
  <link rel="shortcut icon" type="image/jpg" href="◊|path-prefix|images/columns.jpg"/>
  <link rel="stylesheet" type="text/css" media="all" href="◊|path-prefix|css/style.css"/>
</head>
◊(->html body-with-sidebar #:splice? #t)
</html>
