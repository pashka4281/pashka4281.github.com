---
layout: post
title: "Want to embed recommendations from your LinkedIn profile on your blog? This small application may help you."
date: 2014-11-16 16:40
comments: true
categories: LinkedIn Workarounds
description: "How I embedded recommendations from my LinkedIn profile on my blog (and how you can do the same with this small free application)"
keywords: LinkedIn, linkedin, LI, recommendations, embed, blog, site, wordpress
---

<script src="{{ root_url }}/javascripts/posts_specific/linked_in_recommendations.js"></script>

<script type="text/javascript" src="http://platform.linkedin.com/in.js"> 
  api_key: 77x6e890qzbfth
  authorize: true
</script>  


Hi everyone! It's so great to meet you all again here hehe :)
Today is Sunday and that's mean I have much free time I need to spend somehow. 

There is one thing I was curious about for a long time: Why LinkedIn doesn't provide a way to share recommendations on your profile to the public? They provide indeed, but the person who view recommendations should be signed in to LinkedIn to see them. Strange policy. There are many threads on linkedIn developers forums like those: <a href="https://developer.linkedin.com/thread/1430">https://developer.linkedin.com/thread/1430</a> and others. 

So what I actually wanted (and I believe not only me) is an ability to display my LinkedIn profile's recommendations on my blog without forcing it's visitors to sign in with Linked In. I digged lot's of LI documentations, API, forum, stackoverflow etc. and found that LI doesn't allow to do it. Why they do this way is a topic for another post, but now I want to present a small workaround for this problem. 

<img src="http://gdurl.com/uss4" alt="Recommendations rocks!">
<!-- more -->

### Workaround
Ok let's get closer to action: I wrote this small js application that generates script for embedding
recommendations from your LI profile. What it do is simply pulling your recommendations (after you sign in)
and creates a simple script based on them. So when you place the script on your page it will render all of
your recommendations (in the same place where you placed it on your site) and it wouldn't require visitors
of your site to sign in with linked in. Yay! The script will even apply some pretty styling to the recommendations
it embeds (You can easily check out how it looks on my <a href="/about">about page</a>). Success? Not really.
The main problem is that once generated, the script can't update itself, so if you have some changes in your
LI profile (e.g. new recommendation come) you should re-generate the script :( . 

Hope it can be useful for at least somebody.

How to use:
<ul>
  <li>sign in with LinkedIn</li>
  <li>copy the script and paste on your site where you want your recommendations to be displayed</li>
  <li>have fun :)</li>
</ul>


P.S. don't forget to update the script if you got new recommendation or some old one has been changed

### The application

<div id="plugin">
  <script type="in/login" data-onAuth="onLinkedInAuth">
    Hello, <?js= firstName ?> <?js= lastName ?>.
  </script>


  <div class="settings">
    <fieldset>
      <legend>Height:</legend>
      <div>
        <label>
          <input name="height" checked="true" type="radio" value="auto"></input>
          Auto
        </label>
      </div>
      <div>
        <label>
          <input name="height" type="radio" value="manual"></input>
          Fixed (scrolls if exceeds the height)
          <input id="heightInput" type="number" value="150"></input>
        </label>
      </div>
    </fieldset>
  </div>


  <textarea disabled="true" id="output" placeholder="Please Sign in with your LinkedIn account. The code would be generated after that."></textarea>

  <div class="preview">
    <h4>Preview:</h4>
    <div class="content"></div>
  </div>
</div>



<script type="text/javascript">
  $(document).ready(function(){
    $('textarea#output').on('focus', function() {
      var $this = $(this);
      $this.select();
      window.setTimeout(function() {
        $this.select();
      }, 1);
      // Work around WebKit's little problem
      function mouseUpHandler() {
        // Prevent further mouseup intervention
        $this.off("mouseup", mouseUpHandler);
        return false;
      }

      $this.mouseup(mouseUpHandler);
    });
  })
</script>

<style type="text/css">
#plugin{
  margin-top: 15px; margin-bottom: 20px; font-size: 13px; line-height: 17px; color: #333; font-weight: normal; 
  padding: 20px 20px; background: #f4f4f4; border: 1px solid #e9e9e9; border-width: 1px 0;
}
#plugin fieldset{ border: 2px solid #ccc; padding: 10px; margin-bottom: 10px; }
#plugin .settings{ display: none; }
#plugin #output:focus{border-color: #4993e5;}
#plugin #output{
  outline: none; font-size: 10px; min-height: 150px; padding: 5px 6px 4px; margin-top: 2px;
  margin-bottom: 0px; -webkit-box-sizing: border-box; -moz-box-sizing: border-box; box-sizing: border-box;
  -webkit-border-radius: 2px; -moz-border-radius: 2px; -ms-border-radius: 2px; -o-border-radius: 2px;
  border-radius: 2px; -webkit-box-shadow: 0 0 3px rgba(0,0,0,0.1) inset; -moz-box-shadow: 0 0 3px rgba(0,0,0,0.1) inset;
  box-shadow: 0 0 3px rgba(0,0,0,0.1) inset; border: 1px solid #ccc; max-width: 100%; width: 100%; background: #fdfdfd; color: #333;
}
</style>