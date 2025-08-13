#lang pollen

◊(define body-em-size 0.6)
◊(define leading (+ body-em-size 0.5))
◊(define code-em-size (* body-em-size 0.8))
◊(define narrow-aspect-ratio "7/6")
◊(define mobile-aspect-ratio "6/7")
◊(define border-radius "0.25rem")
◊(define masonry-padding "0.4vmax")

◊(define link-color "#0077aa")
◊(define linkactive-color "#00a1e6")

◊(define dark-mode-transition "background 0.3s, color 0.3s")

@import url("fonts.css");
@import url("bulma.min.css");

:root {
    --bg: #ffffff;
    --fg: #000000;
    ◊; Default Bulma footer bg
    --footer-bg: #fafafa;
    --inline-code-fg: #660000;
    ◊; Default Bulma pre bg
    --pre-bg: #f5f5f5;
}

html {
    font-size: 1.8em;
    -moz-text-size-adjust: auto;
    -webkit-text-size-adjust: auto;
}

html[data-theme="dark"] {
    --bg: #111111;
    --fg: #eeeeee;
    --footer-bg: #1a1a1a;
    --inline-code-fg: #ac5353;
    --pre-bg: #1f1f1f;
    color-scheme: dark;
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
    background: var(--bg);
    color: var(--fg);
    transition: ◊|dark-mode-transition|;
}

◊; For flexbox--pre interaction
* {
    min-width: 0;
}

code {
    font-family: "Fira-Mono", monospace;
    font-size: ◊|code-em-size|rem;
    color: var(--inline-code-fg);
    background: var(--pre-bg);
    border-radius: ◊|border-radius|;
    padding: 0.1rem 0.2rem;
    transition: ◊|dark-mode-transition|;
}

.blog-list-date {
    font-family: "Fira-Mono", monospace;
    font-size: ◊|code-em-size|rem;
}

.wrapper {
    min-height: 100%;
    display: grid;
    grid-template-rows: 1fr auto;
    color-scheme: light dark;
}

.content {
    height: 100%;
    min-height: 100%;
    width: 90%;
    margin-left: auto;
    margin-right: auto;
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

.backbutton {
    padding-top: 1.5rem;
    text-align: center;
}

a.backbutton-link {
    font-family: "Fira-Mono", sans-serif;
    font-size: ◊(* body-em-size 3)rem;
    color: var(--fg);
    text-decoration: none;
    transition: ◊|dark-mode-transition|;
}

a.navlink:link, a.navlink:visited {
    text-decoration: none;
    position: relative;
    color: var(--fg);
    transition: ◊|dark-mode-transition|;
}

a.navlink:hover, a.navlink:active {
    color: var(--fg);
    transition: ◊|dark-mode-transition|;
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

a.subheadinglink {
    position: absolute;
    left: -0.7rem;
    top: 50%;
    ◊; Centers on line-height
    transform: translateY(-50%);
    width: 0.7rem;
    color: var(--inline-code-fg);
    font-weight: bold;
    font-size: 0.8rem;
    text-decoration: underline solid transparent;
    opacity: 0.3;
    transition: 0.1s ease-in, ◊|dark-mode-transition|;
}

a.subheadinglink:hover, a.subheadinglink:active {
    text-decoration: underline solid var(--inline-code-fg);
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

.footer {
    font-size: ◊(- body-em-size 0.2)rem;
    text-align: center;
    padding-top: 2rem;
    padding-bottom: 4rem;
    background: var(--footer-bg);
    transition: ◊|dark-mode-transition|;
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
    color: var(--fg);
    transition: ◊|dark-mode-transition|;
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
    color: var(--fg);
    background: var(--pre-bg);
    border-radius: ◊|border-radius|;
    padding: 0.5rem 0.75rem;
    transition: ◊|dark-mode-transition|;
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

.masonry-panel__content {
    padding: ◊|masonry-padding|;
    display: inline-grid;
}

.masonry-img {
    padding: ◊|masonry-padding| 0px ◊|masonry-padding|;
}

.theme-switch {
    z-index: 1000;
}

.toggle-wrapper {
    margin: 0.5rem 10.25rem 0 0;
    font-size: 0.8rem;
    display: flex;
    justify-content: flex-end;
    gap: 0.1rem;
    align-items: self-end;
}

#theme-toggle {
    opacity: 0;
    width: 0;
    height: 0;
}

.theme-switch svg {
    width: auto;
    height: 0.8rem;
    display: block;
    cursor: pointer;
}

.toggle-bg {
    fill: #cccccc;
    transition: fill 0.25s ease;
}

.toggle-thumb {
    fill: white;
    transform: translateX(0);
    transition: transform 0.25s ease;
    transform-box: fill-box;
    transform-origin: center;
}

#theme-toggle:checked + .theme-switch .toggle-bg {
    ◊; light mode inline-code-fg
    fill: var(--inline-code-fg);
}

#theme-toggle:checked + .theme-switch .toggle-thumb {
    transform: translateX(20px);
}

@media screen and (max-aspect-ratio: ◊|mobile-aspect-ratio|) {
    html {
        font-size: 7vw;
    }

    .toggle-wrapper {
        margin: 0.5rem 1.1rem 0 0;
    }
}

@media screen and (max-aspect-ratio: ◊|narrow-aspect-ratio|) {
    .content {
        width: 90%;
        margin-left: auto;
        margin-right: auto;
    }
}

@media screen and (max-aspect-ratio: ◊|narrow-aspect-ratio|) {
    .my-navbar {
        text-align: start;
    }
}

@media screen and (max-aspect-ratio: ◊|narrow-aspect-ratio|) {
    .main {
        margin-right: auto;
    }
}
