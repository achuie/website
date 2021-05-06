#lang pollen

◊(define multiplier 1.3)

@font-face {
    font-family: "JuniusX-Regular";
    src: url("JuniusVF.woff2");
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
    color: red;
    font-size: ◊|multiplier|em;
}

a.navlink:link, a.navlink:visited {
    text-decoration: none;
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
