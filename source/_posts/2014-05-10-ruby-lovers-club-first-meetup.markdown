---
layout: post
title: "Ruby lovers club - first meetup"
date: 2014-05-10 16:05
comments: true
categories: 
---

10/05/14 18:30

<div id="map_canvas" style="height: 200px;"></div>

<script type="text/javascript">
  function initializeMap() {
    var mapCenter = new google.maps.LatLng(50.005843,36.23571);
    var mapOptions = {
      zoom: 15,
      center: mapCenter,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    var map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
    
    var marker = new google.maps.Marker({
      position: mapCenter,
      map: map,
      title: "Все сюда!"
    });
  }

  function loadMapScript() {
    var script = document.createElement("script");
    script.type = "text/javascript";
    script.src = "http://maps.googleapis.com/maps/api/js?sensor=true&callback=initializeMap";
    document.body.appendChild(script);
  }
  $(document).ready(loadMapScript)
</script>

Привет всем! Сегодня 10 мая - первый сбор нашей толпы руби фанов :)
<!-- more -->
В этом блоге будут собраны ссылки, примеры кода и другая информация, которая поможет в процессе обучения юных падаванов Ruby.

Пример кода выглядит так:

``` ruby Кусок Ruby кода
class Foo
  def bar?
    true
  end
end
```

Задача на сегодня - встретиться, познакомиться и пообщаться в спокойной обстановке, обсудить наш план дальнейших действий.
Ок, остался час, начинаем выдвигаться :)
