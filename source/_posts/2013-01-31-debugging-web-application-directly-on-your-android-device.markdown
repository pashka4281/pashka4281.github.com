---
layout: post
title: "Debugging Web Application Directly On Your Android Device"
date: 2013-01-31 17:17
comments: true
categories: [Web, Chrome, Ubuntu, Development]
---

If you take care of how would your web app look on mobile devices this will be definitely halepful. So to make it work you need to satisfy next conditions:

  - Obviously, you'll need an android device you're going to test on (preferably Android 3.2 and higher)
  - Android SDK installed
  - Both desktop and mobile should run Google Chrome Browser (Chrome beta is also supported)
  - USB cable

<!-- more -->
At first, download Android SDK from [official site](http://developer.android.com/sdk/index.html) 
then extract it's content. I use Ubuntu and in my case SDK is located inside of 'bin' folder, 
right under 'home' foler: `~/bin/adt-bundle-linux-x86_64/`. 

When you have SDK installed, connect your mobilde device using USB cable to your desktop. 
But first you need to enable USB debugging on your mobile device, both in Chrome and system settings. 
Once you did it, you need to make sure your device is correctly detected, run "adb" tool for that: <br />
`~$ cd ~/bin/adt-bundle-linux-x86_64/sdk/platform-tools` <br />
`~$ ./adb devices`

You'll get output similar to this:

> List of devices attached <br />
  4df1f0377f5f8fc7    device

So we can see device is listed correctly. Next, enable port forwarding by running this command: <br />
`./adb forward tcp:9222 localabstract:chrome_devtools_remote`

This should yield some output, but in my case it showed nothing.
Now it's time for most interesting! Open Chrome both on Android device and on desktop. 
Follow your desktop browser to this URL `http://localhost:9222/` and're going to see the 
list of opened tabs on your mobile device:

![img](http://farm9.staticflickr.com/8492/8431975033_2fbe3d65fd_z.jpg)

After you have choose one you'll see usual chrome developer tools window:

![img](http://farm9.staticflickr.com/8217/8431995941_0a6485bb3f_z.jpg)

And some corresponding mobile screenshots:

![img](http://farm9.staticflickr.com/8097/8431988489_e8190eef4f_z.jpg)

![img](http://farm9.staticflickr.com/8464/8431989119_1f6748d41e_z.jpg)

Now you can do everything with Chrome dev tools right on your mobile device! Yay!

[Google Original Article with more detailed instructions on how to set up connection between Desktop and mobile Chrome](https://developers.google.com/chrome-developer-tools/docs/remote-debugging)