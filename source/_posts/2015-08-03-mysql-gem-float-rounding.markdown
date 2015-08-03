---
layout: post
title: "mysql gem float rounding"
date: 2015-08-03 14:41
comments: true
categories: [mysql, rails, database, rounding] 
keywords: mysql, rails, mysql2, mysql gem, mysql2 gem, mysql float, mysql float rounding, musql float rails, mysql float rounding rails, rails float rounding, rails unrounding, rails float unrounding, mysql float unrounding, mysql rails float unrounding, mysql float price, mysql rails price float
description: "Float rounding issues in Mysql + Rails when using mysql gem."
---

Working on one of the old Rails app our team found a strange issue related to mysql float numbers.
We basically upgrade the app to make it use rails 4 and rewrite whole bunch of legacy code alongside.
A while ago we were working on part that deals with prices lists. There was a model called Pricelist 
that had a float field to keep prices. Yeah, yeah I know, that's wrong, but this is what we got, and
even despite this, the part dealing with prices worked perfecly fine in old app.
<!-- More -->

But then we came and wrote new code for pricelists. 
And here is what we got. Instead of having numbers like this

* 4.35
* 3.5
* 8.15
and so on

we got their looong versions:

* 4.349859378954873
* 3.482404398085409
* 8.149983838430043


First idea was that database contains values parsed from somewhere outside and old app just rounds them up before showing to the user.
But there was no rounding code and as we disovered later those numbers were entered by hands, so no chanse that someone filled up 10 or so digits after period just to set price.

Second idea was that our new app is doing something wrong, e.g. "unrounding" numbers from the database. We opened mysql console to see what exactly contained our database. 

```sh
mysql> SELECT * FROM prices WHERE id IN(316, 317, 318, 319, 320);                                                                                                                                  
+-------+------------+
| id    | price    |
+-------+------------+
| 316 |       4.35 |
| 317 |       3.32 |
| 318 |       3.12 |
| 319 |       3.02 |
| 320 |       2.82 |
+-------+------------+
```

Hmmm, that meant that some sort of "unrounding" actually happens in rails. Cause data in mysql is correct, right?

Something wrong was in this theory. How could Rails "unround" numbers? That would mean adding some random part to it? That seemd logicless to me so I got another assumption.
What if mysql console lies, what if it doesn't show actual data, but rounds it up instead?
And this was a key to the problem. We found that mysql gem we installed for the new app worked in a different way compared to old app that was not even listed any gems in it's Gemfile 
(perhaps in those days mysql database support was embedded into rails).

Simple switching from mysql to mysql2 helped in our case.

So be carefull when dealing with float fields in mysql + rails, and of course never use floats for storing prices. There are many other much safer ways to do it.

We also found a couple of mentions about exactly the same problem across net:

* [http://stackoverflow.com/questions/23120584/why-does-mysql-round-floats-way-more-than-expected](http://stackoverflow.com/questions/23120584/why-does-mysql-round-floats-way-more-than-expected)
* [http://stackoverflow.com/questions/5411551/what-the-difference-between-mysql-and-mysql2-gem](http://stackoverflow.com/questions/5411551/what-the-difference-between-mysql-and-mysql2-gem)
* [https://github.com/rails/rails/issues/4549](https://github.com/rails/rails/issues/4549)


