#lang pollen

◊(define body-em-size 1.0)
◊(define leading (+ body-em-size 0.5))
◊(define link-color "#0000ee")
◊(define link-gray "#e6e6e6")

@import url("./fonts.css");
@import url("./bulma.min.css");

html, body {
    height: 100%;
    min-height: 100%;
    margin: 0;
    padding: 0;
    overflow: auto;
}

body {
    font-size: ◊|body-em-size|em;
    line-height: ◊leading;
    font-family: "Alegreya Sans", serif;
    font-weight: normal;
}

.content {
    height: 100%;
    min-height: 100%;
    width: 80%;
    margin-left: 0;
    margin-right: auto;
}

.my-navbar, .backbutton {
    padding: 0.5em;
    line-height: ◊(+ leading 0.1)em;
}

.my-navbar {
    font-family: "Alegreya Sans SC", sans-serif;
    font-size: ◊(+ body-em-size 0.3)em;
    text-align: end;
}

.backbutton {
    padding-top: 2em;
    text-align: center;
}

a.backbutton-link {
    font-family: "Fira-Mono", sans-serif;
    font-size: ◊(* body-em-size 3)em;
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
    bottom: 0.0em;
    left: 0;
    width: 0%;
    border-bottom: 1px solid;
    transition: 0.2s cubic-bezier(0.5,0.5,0,1);
}

a.navlink:hover::after {
    width: 100%;
}

a.bodylink:link, a.bodylink:visited {
    text-decoration: underline 8px solid ◊|link-gray|;
    text-decoration-skip-ink: none;
    text-underline-offset: -4px;
    transition: 0.1s;
    color: black;
}

a.bodylink:hover, a.bodylink:active {
    text-decoration: underline 1px solid ◊|link-color|;
    text-decoration-skip-ink: auto;
    text-underline-offset: 2px;
    transition: 0.1s;
    color: ◊|link-color|;
}

.main {
    padding-top: 2.0em;
    display: block flex;
}

.textwrap {
    float: right;
    margin: 1.5em;
}

h1,h2,h3,h4,h5,h6 {
    margin: 0px;
    font-weight: 600;
}

h1 {
    border-top: 1px solid;
    font-size: ◊(+ body-em-size 0.2)em;
}

h2 {
    font-size: ◊(+ body-em-size 0.1)em;
}

h3,h4,h5,h6 {
    font-size: ◊|body-em-size|em;
}

p {
    margin-top: 0.2em;
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
