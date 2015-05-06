---
layout: post
title: "SSH port forwarding: how to?"
date: 2015-05-06 14:29
comments: true
categories: [SSH, pair programming]
keywords: ssh, port forwarding, ssh port forwarding, port forwarding ssh, PAT, pat, server administration, terminal, bash, unix, web development, Pavlo Sirous, pavlosirous
description: "Simple tutorial that explains how to use ssh to setup port forwarding from a remote server down to your local machine"
---

SSH port forwarding

I guess everyone knows how to use SSH to connect local terminal to remote server.
Often usage of ssh is limited to this. But ssh has some other cool features that can be very helpful sometimes. One of them is port forwarding.

This days I often work on a development server doing some pair-programming.
Once we neede to see what emails are going out from the rails app.
When working locally I usually prefer to use letter_opener gem which opens a new tab in a browser with a preview of an email [https://github.com/ryanb/letter_opener](https://github.com/ryanb/letter_opener).
But dev server doesn't have any GUY so that's we couldn't use browser-based tools. That's why decided to use something else, basically mailcatcher [http://mailcatcher.me/](http://mailcatcher.me/).
Mailcatcher is an smtp server that provides http interface that shows all the outgoing emails. 

<!-- More -->

Here's where we're getting closer to the post topic.
The problem we faced is that mailcacher is running on port 1080 (sure this is configurable) which was apparently closed on the server thus making it impossible to access it's admin panel.
A good case for using ssh port worwarding.

```sh
ssh -L 8000:localhost:1080 your.server.com
```

This command forwards a port `1080` on `your.server.com` to port `8000` on your localhost,
so now visiting `http://localhost:8000` will show you the content of something that is located on `http://your.server.com:1080` (mailcatcher web interface in our case). Yay! Problem solved!

I have to add that previous command will also open a regular terminal remote session to your server and if you don't need it, you can append another parameter `-N` to make it just forward a port:

```sh
ssh -L 8000:localhost:1080 your.server.com -N
```

Actually SSH has more interesting features you may like to learn about so here is a couple of resources that gonna help with that:

*  `man ssh` (sure, that simple)
* [https://help.ubuntu.com/community/SSH](https://help.ubuntu.com/community/SSH)
* [http://ubuntuguide.org/wiki/Using_SSH_to_Port_Forward](http://ubuntuguide.org/wiki/Using_SSH_to_Port_Forward)
