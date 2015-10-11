---
---

var posts = [];
{% for post in site.posts limit: site.recent_posts %}{% include post/date.html %}
  posts.push({ link: "{{ root_url }}{{ post.url }}", title: "{{ post.title }}", date: "{{post.date_formatted}}" });
{% endfor %}
recentPostsCallback(posts);
