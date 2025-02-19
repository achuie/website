#lang pollen

◊(define-meta published "?? 02 2025")

◊h1{Setting Up a Server for My Server}

So I set up my homelab, but now I have to make it accessible from outside my apartment. Normally this is trivially done
with port forwarding rules on one's router, but my apartment building has a centralized, building-wide router from our
internet provider that I don't have control over. I could probably call and ask them about it, but knowing Japan I bet
they either don't allow it or hide it behind so many bureaucratic processes and forms as to render it not worth the
while.

There is an alternative, however: SSH tunneling. Specifically, reverse SSH tunneling.
