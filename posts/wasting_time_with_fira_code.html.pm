#lang pollen

◊h1{Wasting Time with Fira Code}

I spend a lot of time in the terminal. At home and at work, most of the tools I use are commandline, so I need a
good-looking font, and Fira Code is second to none. It's an update to Fira Mono, the font Mozilla commissioned from
Carrois Studios (from what I can tell). The letter forms are unique and stylish, without calling too much attention to
themselves or becoming varied enough to cause fatigue. 

However, the update also comes with ligatures. These are controversial, to say the least, and while some are intrusive
and a bit obnoxious, some others are pretty and almost useful. Upon reflection, I realized the ones I like are all ones
that do not mutate the shape of the individual composing glyphs, rather they simply adjust the kerning and x-height to
fit the neighboring glyphs.

TODO bad ligature example
◊img[#:style "width: 6vmax; vertical-align: middle;"
    #:src "https://media.githubusercontent.com/media/achuie/achuie.github.io/master/images/columns.jpg"
    #:alt "Icon"]{} ◊br{}

TODO good ligature example
◊img[#:style "width: 6vmax; vertical-align: middle;"
    #:src "https://media.githubusercontent.com/media/achuie/achuie.github.io/master/images/columns.jpg"
    #:alt "Icon"]{} ◊br{}

So below is a recount of my short endeavor to split these groups of ligatures and strip out the bad ones.

◊h2{TL;DR}

The code is ◊body-link["https://github.com/achuie/dotfiles/tree/master/nix-flakes/firacode"]{here}, and can be built with
the following command if one has Nix installed:
◊code{nix build github:achuie/dotfiles?dir=nix-flakes/firacode}
