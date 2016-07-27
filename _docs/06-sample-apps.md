---
docid: sample-code
title: 示例代码
layout: docs
permalink: /docs/sample-code.html
prev: building-from-source.html
---

## 译者DEMO

官方的项目，编译起来比较困难，如果你仅仅是想看 DEMO 运行效果，我将 DEMO 抽离出来，你直接使用这个[github项目](https://github.com/liaohuqiu/fresco-demo-for-gradle)

*以下原文*

*Note: 示例代码在“非商业使用” License 下，而不是Fresco的BSD License。

你可以在Fresco的Github页面找到一些示例代码，他们只能配合源码一起运行。你需要参考[构建源码](building-from-source.html)。 

### 缩放库

[zoomable library](https://github.com/facebook/fresco/blob/master/samples/zoomable) 实现了一个`ZoomableDraweeView`支持手势缩放。

### 图片库比较App

在这个App中我们比较了[Picasso](http://square.github.io/picasso), [Universal Image Loader](https://github.com/nostra13/Android-Universal-Image-Loader), [Volley](https://developer.android.com/training/volley/index.html), [Glide](https://github.com/bumptech/glide)。

你也可以比较Fresco中使用 OkHttp 和 Volley 的性能差异。

你可以设置图片源于网络或者本地相册，网络图片来源于[Imgur](http://imgur.com).

你可以运行自动化对比测试脚本[run_comparison.py](https://github.com/facebook/fresco/blob/master/run_comparison.py)。 下面这个指令会在一个 ARM-v7 设备上运行脚本:

```./run_comparison.py -c armeabi-v7a```

### 示例App

它显示了 Fresco 的各种用法 - JPEG的渐进加载，动态、加强、简单的WebP，PNG，GIF。我们还示例了Uri中带图片数据的传输用法。

### 圆角示例 

示例了各类圆角、圆形图的用法

### Uri示例

你可以在其中的`TextView`中输入Uri并在`DraweeView`中展示。
