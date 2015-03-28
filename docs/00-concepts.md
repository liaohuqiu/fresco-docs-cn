---
id: concepts
title: 关键概念
layout: docs
permalink: /docs/concepts.html
prev: index.html
next: supported-uris.html
---

## Drawees

Drawees 负责图片的呈现，包含几个组件，有点像MVC模式。

### DraweeView

继承于 [View](http://developer.android.com/reference/android/view/View.html), 负责图片的显示。

一般情况下，使用`SimpleDraweeView` 即可. 简单的用法，在这个页面：[开始使用](index.html) 。

它支持很多自定义效果，参见这里: [自定义显示效果](using-drawees-xml.html).

### DraweeHierarchy

继承于 [Drawable](http://developer.android.com/reference/android/widget/Drawable.html), 包含用于绘制的图像数据。MVC中的M。

If you need to [customize your image's appearance in Java](using-drawees-code.html), this is the class you will deal with.

### DraweeController

The `DraweeController` is the class responsible for actually dealing with the underlying image loader - whether Fresco's own image pipeline, or another.

If you need something more than a single URI to specify the image you want to display, you will need an instance of this class.

### DraweeControllerBuilder

`DraweeControllers` are immutable once constructed. They are [built](using-controllerbuilder.html) using the Builder pattern.

### Listeners

One use of a builder is to specify a [Listener](listening-download-events.html) to execute code upon the arrival, full or partial, of image data from the server.

## Image Pipeline

Behind the scenes, Fresco's image pipeline deals with the work done in getting an image. It fetches from the network, a local file, a content provider, or a local resource. It keeps a cache of compressed images on local storage, and a second cache of decompressed images in memory.

The image pipeline uses a special technique called *pinned purgeables* to keep images off the Java heap. This requires callers to `close` images when they are done with them.  

`SimpleDraweeView` does this for you automatically, so should be your first choice. Very few apps need to use the image pipeline directly.
