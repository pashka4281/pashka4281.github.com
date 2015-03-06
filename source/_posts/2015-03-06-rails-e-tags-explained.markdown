---
layout: post
title: "Rails E-tags explained"
date: 2015-03-06 03:14
comments: true
categories: ["Rails", "HTTP", "Caching", "E-tag"]
description: "How E-tags works for caching and what can we do with them in Rails"
keywords: E-tags, Rails, Ruby, Ruby on Rails, Caching, Pavlo Sirous
---

E-tag is a part of HTTP 1.1 specification and basically a mechanism that helps implement browser caching.
E-tag stands for "entity tag". Let's see how it works.

When browser loads a page for a first time, server renders page's HTML and also creates
MD5 checksum of it which will be send back to browser via headers together with response body. 

![img](http://gdurl.com/E_Av)

<!-- More -->


So this is what approximately happening on server when it generates e-tag:

```sh
require 'digest/md5'
headers['ETag'] = Digest::MD5.hexdigest(response_body)
# => "398b81ab9ecb91a32fee9146fe7b1846"
```

Next, browser receives server's response, renders it and caches somewhere on the disk locally. Also it saves received e-tag.
![img](http://gdurl.com/MjK5)

Now we decide to visit the same page again.
![img](http://gdurl.com/uGYc6)

Browser sends e-tag that we got before (header containing it now called "If-None-Match"
and this is a real mystery for me why they called it this way and not simply "e-tag").
On server side the page got rendered again but this time not immediately sent back to client,
but instead e-tag of it being generated and compared with one received from browser.
If they match response body will be empty and status will be 304 Not Modified.
Browser in his turn when got 304 status, knows that nothing has changed on the page
since last visit thus local cached version of it can be rendered instead.

This way we reduce network usage when there is no need to send same information twice.
But if you were attentive while reading above, you noticed that when we hit the page second time,
server still renders the page before deciding if there were changes.
In Rails there is a way to manually control generating etags on the server - `fresh_when` method
([apidock reference](http://apidock.com/rails/ActionController/ConditionalGet/fresh_when)).
It can take an active record object as an argument and a set of additional parameters. 
Fresh_when method calls `.cache_key()` on a passed object, which is usually a
combination of class name, `id` and `updated_at` columns (e.g. "posts/5-20071224150000").
Having this we can now improve generating etags on the server and prevent page rendering on each request. 


Consider this code example:

```sh
class PostsController < ApplicationController
  def show
    @post = Post.find params[:id]
    fresh_when(@post)
  end
end
```

Instead of generating etag based on whole page's html, we would use cache_key of @post. 
If you want to add more information etag will be generated from, you can pass an array to fresh_when method.

```sh
fresh_when([@post, current_user.id])
```

Or in a more declarative form:

```sh
class PostsController < ApplicationController
  etag { current_author.id }
  etag { current_property.name } # you can add even more then one
  
  def show
    @post = Post.find params[:id]
    fresh_when(@post)
  end
end
```
