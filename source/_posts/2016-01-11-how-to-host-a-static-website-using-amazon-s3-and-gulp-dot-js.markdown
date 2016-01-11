---
layout: post
title: "How to host a static website using Amazon S3 and gulp.js"
date: 2016-01-11 21:04
comments: true
categories: [Web, Hosting, Gulp] 
keywords: Web, Hosting, static, website, gulp, Gulp, gulp.js, Gulp.js, html amazon, amazon s3, s3, cheap hosting, tutorial
description: "A simple way to setup and use amazon s3 as a hositing provider for a static html website"
---


Hosting website could be tricky. No seriously, there are tons of "plug and play" hosting solutions for Rails, PHP, Node etc like Heroku or EngineYard or even Digital Ocean. But when it comes to a regular static html website there are nothing even close to that variety. I was looking some place to put my pasvlosirous.com into. And didn't find literally anything interesting. Just nothing at all. Some of the services asks 8 bucks for static html hosting. 8 bucks Carl!
Suddenly I realized that I already know the service I was looking for. It's Amazon S3. Yeah, why not? Powerful, cheap and fast - exactly what I need. Accordingly to their [docs](http://docs.aws.amazon.com/AmazonS3/latest/dev/request-rate-perf-considerations.html) s3 can handle up to 800 requests per second (or even more if there is a need). Maybe not so impressive if you own something like twitter but more then enough for our needs. Just left to figure out a simple way to compress stylesheets/javascripts, minify and gzip html and put all that crap on our s3 bucket - in other words we need a simple way to deploy our website. Ideally to have single command that will do all necessary things.

<!-- More -->
Here is where it comes to Gulp.js. Gulp is a javascript tasks runner. Just like Make or Rake but for JS. And it has all the required plugins we need including plugins for publishing files to S3. Check it out http://gulpjs.com/plugins/.

To start using gulp you would need to create a gulpfile.js in the root of your website's folder. Besides that I have created a file to keep my aws credentials - aws.json.
![img](http://gdurl.com/nJ81)


{% gist 3e65bc999371f9a31758 gulpfile.js pashka4281 %}

Here we simply create a singe gulp task that utilizes all of the plugins we required before.
So now to deploy you simply call `> gulp deploy` and wait untill it finishes.

Btw, need to say that I tried several s3 plugins before found one that I was able to set up and run properly. Other ones were just too complicated or broken, fortunately there are tons of plugins so if one didn't work you can always find another one.
