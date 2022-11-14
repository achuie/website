#lang pollen

◊(define body-em-size 1.2)
◊(define leading (number->string (* body-em-size 1.2)))
◊(define link-color "#0000ee")
◊(define link-gray "#e0e0e0")

@import url("https://indestructibletype.com/fonts/Bodoni/Bodoni.css");
@import url("https://indestructibletype.com/fonts/Besley.css");

html, body {
    height: 100%;
    min-height: 100%;
    margin: 0;
    padding: 0;
    overflow: auto;
}

body {
    font-size: ◊|body-em-size|em;
    line-height: ◊|leading|;
    font-family: "Besley", serif;
}

.content {
    height: 100%;
    min-height: 100%;
    display: table;
    width: 75%;
    margin-left: 0;
    margin-right: auto;
}

.navbar-cell {
    display: table-cell;
    width: 40%;
}

.navbar {
    padding: 0.5em;
    font-size: ◊|body-em-size|em;
    text-align: right;
    font-family: "Bodoni 11";
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
    bottom: 0;
    left: 0;
    width: 0%;
    border-bottom: 1px solid;
    transition: 0.2s cubic-bezier(0.5,0.5,0,1);
}

a.navlink:hover::after {
    width: 100%;
}

a.bodylink:link, a.bodylink:visited {
    text-decoration: underline 2px solid ◊|link-gray|;
    color: black;
}

a.bodylink:hover, a.bodylink:active {
    text-decoration: underline 1px solid ◊|link-color|;
    color: ◊|link-color|;
}

.main-cell {
    display: table-cell;
    width: 60%;
}

.main {
    padding: 0.5em;
}

.textwrap {
    float: right;
    margin: 0.5em;
}

h1,h2,h3,h4,h5,h6 {
    font-family: "Bodoni 24";
    margin: 0px;
}

h1 {
    font-feature-settings: "smcp";
    border-top: 1px solid;
}

p {
    margin-top: 0.2em;
}
