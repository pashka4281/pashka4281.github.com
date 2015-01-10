---
layout: post
title: "Glad to present you 'CommonTime' tool (a small free app that helps working with people from different timezones)"
date: 2015-01-10 02:24
comments: true
categories: ["Freelancing", "Remote work", "TimeZones", "RaphaelJS", "Vector Graphics"]
description: "'CommonTime' tool (a small free app that helps working with people from different timezones)"
keywords: Freelancing, Remote work, TimeZones, RaphaelJS, Vector Graphics, small apps, Pavlo Sirous, Web design, freelancing, remote work, vector design, vector graphics
---

Happy to welcome you, dear visitor of my blog!

Want to congratulate you with passed Christmas and New Year. That was a great year (a hard year for my country, but it brought more hopes and many happy moments, hope for you as well).
During the holiday nobody worked, so I had some free time that I spent on learning new stuff (got acknowledged with Web components and Polymer.js, but that is another story that I'm definitely going to cover in later posts) and building one small application that I call "CommonTime" as well.

<!-- More -->

The short story: as a freelance developer working often with abroad clients I usually face problem with finding comfortable time to communicate for both me and the client. That brings some difficulties and usually means googling the time difference between us, calculating the number of hours, etc. After missing another meeting with the client because of misunderstanding our timezones (a call was scheduled at 4:00 am my local time:) ) I started seriously thinking about creating a simple solution for that.
Since that is a repetitive task, it can be solved once and forever. 

What I did is took my brush, a sheet of paper and started mastering (joking, just got to my laptop and begun reading Raphael docs - but that sounds not romantic at all). What I got as an output - a small app that should help you forget about googling client's timezone and calculating the hours difference between you.

What is CommonTime?
---------
Here is a quote from github readme file:

> Small tool to find common working hours in different time zones  
> It helps freelancers who work with clients abroad to easily find (and share) common working hours (and overlapping).
> it has simple intuitive UI built with RaphaelJS.
> How to use it:
>
> 1 select your timezone, then your client's one.
> 
> 2 specify your working hours as well as your client's.
> 
> You'll be able to see where your working hours overlaps and share it with each other 
(by uniq link that is generated automatically)
> 
> Time format is an option as well (12/24 hours)


Here is how it all looks like (yeah I took some inspirations from apps like Rubular.com and Paletton.com)
![img](http://gdurl.com/e7H1)

A link:
[http://commontime.info](http://commontime.info)

Github repository:
[https://github.com/pashka4281/common_time](https://github.com/pashka4281/common_time)


What it basically allows to do is fill in your working hours (as well as client's) with moving arc curves alongside two circles: your one and client one respectfully.
After that you should select timezones for you and for client. When it is done, circles will rotate to represent each timezone's offset compared to utc 0:00
and you'll get a graphically visualized intersection of working hours for you and for second person. Also you can input emails to get gravatar images associated for both people.
The main feature is sharing - you can send a link to the second person and confirm/get updates from him accordingly.
Sweeeet!


This is a very pilot version, I have a bunch of ideas of how to improve it and add some new features, but I'd like to hear a feedback from you first. Drop a line in a comment box below this post.
Please help me with your ideas! I think It can became useful for many people that has similar problems.
Thanks!