---
layout: post
title: "Node JS ecosystem from Rails developer perspective - part1"
date: 2014-06-01 04:50
comments: true
categories: [NodeJs, EpressJS, Ubuntu, Web]
---

That was a rainy night of Saturday when I was sitting down and reading some blog I found a notice about Node. Yay, now I know how to spend rest of the eve - I thought :)

Honestly saying, some time ago I have already made "first steps" in writing server side js using node, but that was so long ago so I decided to try again and go further that first time.


So let's start from installing npm (node package manager - similar to gem from rails). I had it already installed but for those who just starting follow next steps (quote taken from ubuntu community).
<!-- more -->

Step 1 - installing node
---

Those are pretty easy and not involving compiling stuff:

> You can use this node.js PPA:
> 
> `ppa:chris-lea/node.js`
>
> If you're on Ubuntu Server, first do this:
>
> `$ sudo apt-get install python-software-properties`
>
> Then, do this:
>
> `$ sudo add-apt-repository ppa:chris-lea/node.js`
>
> `$ sudo apt-get update`
>
> `$ sudo apt-get install nodejs`
>
> Then, you have the latest version of node.js installed.

Then, check if node was installed correctly:

`$ node -v`

Step 2 - Install NPM
---

Simply run the NPM install script:

curl https://npmjs.org/install.sh | sudo sh
And then check it works:

npm -v
That's all.


Step 3 - Creating basic skeleton of you very first Node web app
---
For accomplishing this step I strongly recommend to use ExpressJs - a small npm package (aka gem) that boost your node app with such nice features as routing, template handling (Jade by default --  very similar to haml) and some other useful stuff. Creating server with expressjs is also simple proccessas well as configuring it. Node app has no strict folders structure (as Rails do) but it nice to have some place to start of. There are plently much app template/seed projects available out there, let's use on of them that contains basic blog application:

`https://github.com/btford/angular-express-blog`

(yeah-yeah you have already noticed this seed project includes AngularJS :) -- we'll get back to it a bit later )

So:

`$ git clone https://github.com/btford/angular-express-blog.git && cd angular-express-blog`


Then run

`$ npm install` to install all the app dependencies (this is similar to bundle install in rails. This command will install dependencies described in package.json file -- node analog for Gemfile. You can edit it to add required libs/plugins)

This should run smoothly and finaly we're able to run our app!
`$ node app.js`

`$ Express server listening on port 3000 in development mode`

Now open your favourite browser and point it to http://localhost:3000

This is what you would see, your first hand-made Node js blog. We did it :) 

![](https://farm3.staticflickr.com/2906/14314489362_f2296fd5ab_b.jpg)


Step 4 - application structure
---

Basically the structure of the app skeleton we have copied looks like this:

```sh
README.md
app.js              --> app config
package.json        --> for npm
public/             --> all of the files to be used in on the client side
  css/              --> css files
    app.css         --> default stylesheet
  img/              --> image files
  js/               --> javascript files
    app.js          --> declare top-level app module
    controllers.js  --> application controllers
    directives.js   --> custom angular directives
    filters.js      --> custom angular filters
    services.js     --> custom angular services
    lib/            --> angular and 3rd party JavaScript libraries
      angular/
        angular.js            --> angular js
        angular.min.js        --> minified angular js
        angular-*.js          --> angular add-on modules
        version.txt           --> version number
routes/
  api.js            --> route for serving JSON
  index.js          --> route for serving HTML pages and partials
views/
  index.jade        --> main page for app
  layout.jade       --> doctype, title, head boilerplate
  partials/         --> angular view partials (partial jade templates)
    addPost.jade
    deletePost.jade
    editPost.jade
    index.jade
    readPost.jade
```

It's pretty self-explanary, I'll stop only for certain moments to clarify.
The main starting point of the app is actually app.js file. it combines some `require` statements to load external libs, code for setting up express server and define some config parameters to it (e.g. templating engine, running port, routes etc.).

Step 5 - ExpressJS routings
---

Special quote for routes. They have some differences comparing to Rails's. The app.js contains routes only constraints but their definitions are placed under ./routes folder. 
Instead of mapping an http route to controller's action (like rails do) express routes defines make rails controllers job as well: they define what to do with the request (e.g. redirect it) or what data should be sent for a particular request.
Consider example:

We requring definitions contained in ./routes/api.js file and place it to api variable
`var api = require('./routes/api');`

Then to map `posts` definition to get request for '/api/posts' path we do this:
`app.get('/api/posts', api.posts);`

This would work since /routes/api.js contains definition named 'posts':

```sh
exports.posts = function (req, res) {
  var posts = [];
  data.posts.forEach(function (post, i) {
    posts.push({
      id: i,
      title: post.title,
      text: post.text.substr(0, 50) + '...'
    });
  });
  res.json({
    posts: posts
  });
};
```

So when client requests /api/posts via GET 'posts' function will be called.
The common format of the route definition fuction is
`function(req, res){ ... }`

Req and res objects stands for Request and Response respectively. They have plently on methods to deal with request and response, but in our case we want to render json, this goal is accomplished by calling json function on res object and passing desired json as an argument:

`function(req, res){ res.json({ foo: "bar" }) }`


This way you can easily create json API for your client side code.
Another way of using routes - rendering templates. Example from our app you can inspecting `./routes/index.js` file.
Similar to rendering json but using 'render' function on res object:

```sh
function(req, res){
  res.render('index');
};
```

It would pick up and render template 'index.jade' under ./views folder.

Step 6 - Jade templates
---
More detailed info about jade templating language can be found here http://jade-lang.com/
It has similar to haml syntax so if you know how to write haml you'll be easy to deal with jade. (Need to say, I'm sure you can find plugins for haml support as well).
Most important notice for us as rails developers - it supports layouts, partials and other good stuff we used to work with in Rails.

Jade layout should contain `block body` code. Thi is a place where templates will  be included:

```sh
!!!
html(ng-app="myApp")
  head
    meta(charset='utf8')
    base(href='/')
    title Angular Express Seed App
    link(rel='stylesheet', href='/bower_components/bootstrap/dist/css/bootstrap.min.css')
    link(rel='stylesheet', href='/css/app.css')
  body
    include shared/navbar
    .container
      block body
```

`include shared/navbar` will include navbar.jade partial located inside ./views/shared folder.

BTW, if you're using sublime2 as you text editor there is a simple tutorial of adding jade syntax highlighting to it:
> Hit Command-Shift-P to open up the Command Palette, where you can type "install package".   Hit enter and it will open up another search box.
> Type "jade" and it should autocomplete to the Jade package.  Hit enter to install the package.
> Restart Sublime Text 2.

That's it for layouts. As for views, they should contain layout name which should be used for rendering:

```sh
extends layout

block body
  div.container
    Hello!
```


`extend layout` here says that this view should be rendered under layout named "layout" :)

So that's it for this post, in next posts I'll tell you how angular works for this app, how to deal with assets using Bower, setting up database connection and even bringing some ORM functionality to you nodeJs app. Stay tuned!
Questions are really welcome :)
