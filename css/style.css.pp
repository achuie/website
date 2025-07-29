#lang pollen

◊(define body-em-size 0.6)
◊(define leading (+ body-em-size 0.5))
◊(define code-em-size (* body-em-size 0.8))
◊(define narrow-aspect-ratio "7/6")
◊(define mobile-aspect-ratio "6/7")
◊(define border-radius "0.25rem")

◊(define link-color "#0077aa")
◊(define linkactive-color "#00a1e6")
◊(define inline-code-color "#660000")

@import url("fonts.css");
@import url("bulma.min.css");

html {
    font-size: 1.8em;
    -moz-text-size-adjust: auto;
    -webkit-text-size-adjust: auto;
}

@media screen and (max-aspect-ratio: ◊|mobile-aspect-ratio|) {
    html {
        font-size: 7vw;
    }
}

html, body {
    min-height: 100%;
    height: 100%;
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

◊; For flexbox--pre interaction
* {
    min-width: 0;
}

code {
    font-family: "Fira-Mono", monospace;
    font-size: ◊|code-em-size|rem;
    color: ◊|inline-code-color|;
    border-radius: ◊|border-radius|;
    padding: 0.1rem 0.2rem;
}

.blog-list-date {
    font-family: "Fira-Mono", monospace;
    font-size: ◊|code-em-size|rem;
}

.wrapper {
    min-height: 100%;
    display: grid;
    grid-template-rows: 1fr auto;
}

.content {
    height: 100%;
    min-height: 100%;
    width: 90%;
    margin-left: auto;
    margin-right: auto;
}

@media screen and (max-aspect-ratio: ◊|narrow-aspect-ratio|) {
    .content {
        width: 90%;
        margin-left: auto;
        margin-right: auto;
    }
}

◊; Bulma column padding default is 0.75rem.
.column {
    padding: 0.5rem;
}

.my-navbar, .backbutton {
    padding-top: 1rem;
    line-height: ◊(+ leading 0.1)rem;
}

.my-navbar {
    font-family: "Alegreya Sans SC", sans-serif;
    font-size: ◊(+ body-em-size 0.2)rem;
    text-align: end;
}

@media screen and (max-aspect-ratio: ◊|narrow-aspect-ratio|) {
    .my-navbar {
        text-align: start;
    }
}

.backbutton {
    padding-top: 1.5rem;
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

a.bodylink:hover, a.bodylink:active, a.subheadinglink:hover, a.subheadinglink:active {
    color: ◊|linkactive-color|;
    text-decoration: underline solid ◊|linkactive-color|;
}

a.subheadinglink {
    position: absolute;
    left: -0.7rem;
    top: 0rem;
    width: 0.7rem;
    color: ◊|link-color|;
    font-weight: normal;
    text-decoration: underline solid transparent;
    opacity: 0;
    transition: 0.1s ease-in;
}

.linkable-heading {
    position: relative;
    padding-left: -1.5rem;
}

.content h2:hover a.subheadinglink, .content h3:hover a.subheadinglink, .content h4:hover a.subheadinglink, .content h5:hover a.subheadinglink, .content h6:hover a.subheadinglink {
    opacity: 1;
}

.main {
    padding-top: 2rem;
    margin-right: 7rem;
    display: block flex;
}

@media screen and (max-aspect-ratio: ◊|narrow-aspect-ratio|) {
    .main {
        margin-right: auto;
    }
}

.footer {
    font-size: ◊(- body-em-size 0.2)rem;
    text-align: center;
    padding-top: 2rem;
    padding-bottom: 4rem;
}

.footer-separator {
    font-family: "Fira-Mono", sans-serif;
    font-size: ◊(+ body-em-size 0.1)rem;
    color: #992600;
}

.textwrap {
    float: right;
    margin: 1.5rem;
}

◊; Bulma content classes.
.content h1, .content h2, .content h3, .content h4, .content h5, .content h6 {
    margin-bottom: 0px;
    color: black;
}

.content h1 {
    border-top: 1px solid;
    padding-top: 5px;
    padding-bottom: 1rem;
    font-size: ◊(+ body-em-size 0.2)rem;
}

.post-title {
    display: flex;
    justify-content: space-between;
    align-items: top;
}

.post-date {
    font-size: ◊|body-em-size|rem;
    font-style: italic;
    font-weight: normal;
}

.content h2 {
    font-size: ◊(+ body-em-size 0.1)rem;
}

.content h3, .content h4, .content h5, .content h6 {
    font-size: ◊|body-em-size|rem;
}

.content pre {
    max-width: inherit;
    font-size: ◊|code-em-size|rem;
    overflow: scroll;
    color: black;
    border-radius: ◊|border-radius|;
    padding: 0.5rem 0.75rem;
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
    display: inline-grid;
}

.masonry-img {
    padding: ◊|masonry-padding| 0px ◊|masonry-padding|;
}
