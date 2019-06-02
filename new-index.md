---
layout: home
title: Fresco | 图片管理库
id: home
---

<div class="gridBlock">
<div class="featureBlock twoByGridBlock" markdown="1">
### Image Pipeline

Fresco 的 `Image Pipeline` 的模块负责从网络，从本地文件系统、本地资源加载图片。为了保存数据并减少 CPU 使用，它采用了 3 级缓存设计（2 级内存，1 级内部存储空间）。

</div>
<div class="featureBlock twoByGridBlock" markdown="1">
### Drawees

Fresco 的 `Drawees` 模块会在图片加载完成前显示占位图，加载成功后自动显示图片。当图片不再显示在屏幕上时，它会自动地释放内存。
</div>
</div>

## 特性

<div class="gridBlock">
<div class="featureBlock twoByGridBlock" markdown="1">
### 内存管理

解压后的图片 —— Android 中的 `Bitmap` —— 会占用大量的内存。大的内存占用势必引发更加频繁的 GC。在 5.0 以下，GC 将会显著地引发界面卡顿。

在 5.0 以下系统，Fresco 将图片放到一个特别的内存区域。当然，在图片不显示的时候，占用的内存会自动被释放。这会使得 APP 更加流畅，减少因图片内存占用而引发的崩溃。

Fresco 在低端机器上表现一样出色，你再也不用因图片内存占用而思前想后。

</div>
<div class="featureBlock twoByGridBlock" markdown="1">
### 图片加载

Fresco 的 `Image Pipeline` 允许你用多种方式来自定义图片加载过程，比如：

* 为同一个图片指定不同的 URI，或者使用本地缓存中的图片
* 先显示一个低清晰度的图片，等高清图下载完之后再显示高清图
* 加载完成回调通知
* 对于本地图片，如有 EXIF 缩略图，在完整片图加载完成之前，可先显示缩略图（仅支持本地图片）
* 缩放或旋转图片
* 对已下载的图片再次处理
* 支持 WebP 解码，即使在早先对 WebP 支持不完善的 Android 系统上也能正常使用

</div>
<div class="featureBlock twoByGridBlock" markdown="1">
### 图片绘制

Fresco 的 `Drawees` 负责显示。它提供了一些有用的特性：

* 自定义缩放图片时的焦点，而不仅仅是围绕中心缩放
* 支持圆角图，当然圆圈也行
* 加载图片失败后，允许用户点击占位图以重新加载
* 自定义背景图、覆盖图，或进度条
* 指定用户按压时的覆盖图

</div>
<div class="featureBlock twoByGridBlock" markdown="1">
### 图片的渐进式呈现

渐进式的 JPEG 图片格式已经流行数年了。渐进式图片格式支持先呈现低分辨率的图片，然后随着图片的继续加载，逐渐呈现更清晰的图片。这为慢网络情况下的用户带来更好的用户体验。

Android 本身的图片库不支持此格式，但是 Fresco 支持。使用时，和往常一样，仅仅需要提供一个图片的 URI 即可，剩下的事情，Fresco 会处理好的。

</div>
<div class="featureBlock twoByGridBlock" markdown="1">
### 动态图片

加载 Gif 图和 WebP 动图在任何一个 Android 开发者眼里都是一件非常头疼的事情。每一帧都是一张很大的 `Bitmap`，每一个动画都有很多帧。Fresco 让你忘记这些烦恼，它会处理好每一帧并管理好你的内存。
</div>
</div>

<div class="featureBlock twoByGridBlock" markdown="1">
## DEMO

官方的项目，编译起来比较困难，如果你仅仅是想看 DEMO 运行效果，我将 DEMO 抽离出来，你直接使用这个 [Github 项目](https://github.com/liaohuqiu/fresco-demo-for-gradle)
