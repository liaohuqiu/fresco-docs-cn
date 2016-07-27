---
docid: wrap-content
title: wrap_content的限制
layout: docs
permalink: /docs/wrap-content.html
prev: gotchas.html
next: shared-transitions.html
---

### 为什么不支持`wrap_content`？

> 人们经常会问，为什么Fresco中不可以使用`wrap_content`？

主要的原因是，Drawee永远会在[getIntrinsicHeight](http://developer.android.com/reference/android/graphics/drawable/Drawable.html#getIntrinsicHeight\(\))/[getIntrinsicWidth](http://developer.android.com/reference/android/graphics/drawable/Drawable.html#getIntrinsicWidth\(\))中返回-1。

这么做的原因是 Drawee 不像ImageView一样。它同一时刻可能会显示多个元素。比如在从占位图渐变到目标图时，两张图会有同时显示的时候。再比如可能有多张目标图片（低清晰度、高清晰度两张）。如果这些图像都是不同的尺寸，那么很难定义"intrinsic"尺寸。

如果我们要先用占位图的尺寸，等加载完成后再使用真实图的尺寸，那么图片很可能显示错误。它可能会被根据占位图的尺寸来缩放、裁剪。唯一防止这种事情的方式就只有在图片加载完成后强制触发一次layout。这样的话不仅会影响性能，而且会让应用的界面突变，很影响用户体验！如果用户正在读一篇文章，然后在图片加载完成后整篇文章突然向下移动，这是非常不好的。

所以你必须指定尺寸或者用`match_parent`来布局。

你如果从服务端请求图片，服务端可以做到返回图片尺寸。然后你拿到之后通过[setLayoutParams](http://developer.android.com/reference/android/view/View.html#setLayoutParams(android.view.ViewGroup.LayoutParams)) 来给View设置宽高。

当然如果你必须要使用`wrap_content`，那么你可以参考StackOverflow上的一个[回答](http://stackoverflow.com/a/34075281/3027862)。但是我们以后会移除这个功能，[Ugly things should look ugly](https://youtu.be/qCdpTji8nxo?t=890)。
