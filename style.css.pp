#lang pollen

◊(define body-em-size 1.1)
◊(define leading (* body-em-size 1.3))
◊(define link-color "#0000ee")
◊(define link-gray "#e0e0e0")

@import url("https://indestructibletype.com/fonts/Besley.css");

html, body {
    height: 100%;
    min-height: 100%;
    margin: 0;
    padding: 0;
    overflow: auto;
}

body {
    font-size: 1.1em;
    line-height: 1.43;
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
    font-size: 1.2em;
    text-align: right;
    font-feature-settings: "smcp";
    font-weight: 100;
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
    margin: 0px;
}

h1 {
    border-top: 1px solid;
    font-size: 1.2em;
}

h2 {
    font-size: 1.15em;
}

h3,h4,h5,h6 {
    font-size: 1.1em;
}

p {
    margin-top: 0.2em;
}
