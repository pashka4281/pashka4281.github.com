---
layout: post
title: "ssh replacement: meet Mosh"
date: 2014-11-12 15:43
comments: true
categories: [SSH, mosh, server administration]
keywords: ssh, mosh, server administration, latency compensation, terminal, bash, unix, web development, Pavlo Sirous
description: "The alternative to ssh: meet Mosh - new remote terminal client. Pavlo Sirous blog."
---


SSH probably the most wide-spred tool used by thouthands of hackers/ system administrators all over the world to connect to remote servers.
And while it is simple to use and has been pre-installed on many OS systems, it has some problems as well.
I think you know some "dropped" issues or "timed-out" issues especially when you have unstable internet connection. Rick Cogley has recently posted 
[some workarounds](http://rick.cogley.info/articles/2013/12/14/keeping-ssh-alive/) to fix ssh. 

<!-- more -->

##### Any solution?
So in my turn I wanted to present another tool called [Mosh](https://github.com/keithw/mosh).
![img](http://gdurl.com/7jVw)
Mosh is an alternative remote terminal client that has some great benefits over ssh.

- First and the most important for me - it has no problems with connection.
  At least I haven't noticed a one for time I use it. Even when you leaved your
  remote session inactive for many hours, or temporarily lost internet connection.

- Second - is it's speed. Mosh has some kind of latency compensation. 
  When you types symbols displays immediately after you pressed button and the same time
  they begin being sent to the server. When you quickly types on a low-speed connection you
  could notice how it works: 

  ![img](http://gdurl.com/2tos)

  Underlined characters means that mosh client has not yet got a confirmation from the server about accepting those letters. When it is done, underlines are removed.

It has more cool features like correct that you can read about on [official docs page](https://mosh.mit.edu/).
Even more, there is an [android client](https://play.google.com/store/apps/details?id=com.sonelli.juicessh) for true hackers that do things on the go :)

One serious limitation I think is the need to install additional packages both on client and server while you get ssh out of the box on most operating systems. 