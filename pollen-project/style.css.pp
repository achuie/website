#lang pollen

◊(define multiplier 1.3)

@font-face {
    font-family: "JuniusX-Regular";
    src: url("Junicode-New/webfiles/JuniusVF.woff2");
}

html, body {
    height: 100%;
    min-height: 100%;
    margin: 0;
    padding: 0;
    overflow: auto;
}

body {
    font-size: ◊|multiplier|em;
    line-height: ◊|multiplier|;
    font-family: "JuniusX-Regular", serif;
}

.navbar {
    font-size: ◊|multiplier|em;
}

a.navlink:link, a.navlink:visited {
    text-decoration: none;
    position: relative;
    color: #000000;
}

a.navlink:hover, a.navlink:active {
    color: #000000;
}

a.navlink:after {
    content: "";
    position: absolute;
    bottom: 0;
    left: 0;
    width: 0%;
    border-bottom: 1px solid;
    transition: 0.2s;
}

a.navlink:hover:after {
    width: 100%;
}

.main {
    width: 50%;
    margin-left: auto;
    margin-right: auto;
}

h1 {
    font-feature-settings: "smcp";
    border-top: 1px solid;
}
