#lang pollen

◊(define body-em-size 0.7)
◊(define leading (+ body-em-size 0.5))
◊(define link-color "#0077aa")
◊(define linkactive-color "#00a1e6")

@import url("./fonts.css");
@import url("./bulma.min.css");

html { font-size: 2.4vw; }

html, body {
    height: 100%;
    min-height: 100%;
    margin: 0;
    padding: 0;
    overflow: auto;
}

body {
    font-size: ◊|body-em-size|rem;
    line-height: ◊leading;
    font-family: "Alegreya Sans", serif;
    font-weight: normal;
    color: black;
}

.content {
    height: 100%;
    min-height: 100%;
    width: 80%;
    margin-left: 0;
    margin-right: auto;
}

@media screen and (max-width: 769px) {
    .content {
        width: 90%;
        margin-left: auto;
        margin-right: auto;
    }
}

.my-navbar, .backbutton {
    padding: 0.5rem;
    line-height: ◊(+ leading 0.1)rem;
}

.my-navbar {
    font-family: "Alegreya Sans SC", sans-serif;
    font-size: ◊(+ body-em-size 0.2)rem;
    text-align: end;
}

.backbutton {
    padding-top: 2rem;
    text-align: center;
}

a.backbutton-link {
    font-family: "Fira-Mono", sans-serif;
    font-size: ◊(* body-em-size 3)rem;
    color: black;
    text-decoration: none;
}

a.navlink:link, a.navlink:visited {
    text-decoration: none;
    position: relative;
    color: black;
}

a.navlink:hover, a.navlink:active {
    color: black;
}

a.navlink::after {
    content: "";
    position: absolute;
    bottom: 0.0rem;
    left: 0;
    width: 0%;
    border-bottom: 1px solid;
    transition: 0.2s cubic-bezier(0.5,0.5,0,1);
}

a.navlink:hover::after {
    width: 100%;
}

a.bodylink:link, a.bodylink:visited {
    color: ◊|link-color|;
    text-decoration: underline solid transparent;
    transition: 0.1s ease-in;
}

a.bodylink:hover, a.bodylink:active {
    color: ◊|linkactive-color|;
    text-decoration: underline solid ◊|linkactive-color|;
}

.main {
    padding-top: 2.0rem;
    display: block flex;
}

.textwrap {
    float: right;
    margin: 1.5rem;
}

h1,h2,h3,h4,h5,h6 {
    margin: 0px;
}

h1 {
    border-top: 1px solid;
    font-size: ◊(+ body-em-size 0.2)rem;
}

h2 {
    font-size: ◊(+ body-em-size 0.1)rem;
}

h3,h4,h5,h6 {
    font-size: ◊|body-em-size|rem;
}

p {
    margin-top: 0.2rem;
}

.masonry-layout {
    column-count: 2;
    column-gap: 0;
    height: 100%;
    width: 100%;
}

.masonry-panel {
    break-inside: avoid;
}

◊(define masonry-padding "0.4vmax")

.masonry-panel__content {
    padding: ◊|masonry-padding|;
}

.masonry-img {
    padding: ◊|masonry-padding| 0px ◊|masonry-padding|;
}
