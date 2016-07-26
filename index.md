---
layout: home
title: Fresco | 专为ANDROID加载图片
id: home
---

<div class="gridBlock">
<div class="featureBlock twoByGridBlock" markdown="1">
### Image Pipeline

Fresco 中设计有一个叫做 **Image Pipeline** 的模块。它负责从网络，从本地文件系统，本地资源加载图片。为了最大限度节省空间和CPU时间，它含有3级缓存设计（2级内存，1级文件）。

</div>
<div class="featureBlock twoByGridBlock" markdown="1">
### Drawees

Fresco 中设计有一个叫做 **Drawees** 模块，它会在图片加载完成前显示占位图，加载成功后自动替换为目标图片。当图片不再显示在屏幕上时，它会及时地释放内存和空间占用。

</div>
</div>

## 特性

<div class="gridBlock">
<div class="featureBlock twoByGridBlock" markdown="1">
### 内存管理

解压后的图片，即Android中的`Bitmap`，占用大量的内存。大的内存占用势必引发更加频繁的GC。在5.0以下，GC将会显著地引发界面卡顿。

在5.0以下系统，Fresco将图片放到一个特别的内存区域。当然，在图片不显示的时候，占用的内存会自动被释放。这会使得APP更加流畅，减少因图片内存占用而引发的OOM。

Fresco 在低端机器上表现一样出色，你再也不用因图片内存占用而思前想后。

</div>
<div class="featureBlock twoByGridBlock" markdown="1">
### 图片加载

Fresco的**Image Pipeline**允许你用很多种方式来自定义图片加载过程，比如：

* 为同一个图片指定不同的远程路径，或者使用已经存在本地缓存中的图片
* 先显示一个低清晰度的图片，等高清图下载完之后再显示高清图
* 加载完成回调通知
* 对于本地图，如有EXIF缩略图，在大图加载完成之前，可先显示缩略图
* 缩放或者旋转图片
* 对已下载的图片再次处理
* 支持WebP解码，即使在早先对WebP支持不完善的Android系统上也能正常使用！ 

</div>
<div class="featureBlock twoByGridBlock" markdown="1">
### 图片绘制

Fresco 的 Drawees 设计，带来一些有用的特性：

* 自定义居中焦点
* 圆角图，当然圆圈也行
* 下载失败之后，点击重现下载
* 自定义占位图，自定义overlay, 或者进度条
* 指定用户按压时的overlay

</div>
<div class="featureBlock twoByGridBlock" markdown="1">
### 图片的渐进式呈现

渐进式的JPEG图片格式已经流行数年了，渐进式图片格式先呈现大致的图片轮廓，然后随着图片下载的继续，呈现逐渐清晰的图片，这对于移动设备，尤其是慢网络有极大的利好，可带来更好的用户体验。

Android 本身的图片库不支持此格式，但是Fresco支持。使用时，和往常一样，仅仅需要提供一个图片的URI即可，剩下的事情，Fresco会处理。

</div>
<div class="featureBlock twoByGridBlock" markdown="1">
### 动图加载

加载Gif图和WebP动图在任何一个Android开发者眼里看来都是一件非常头疼的事情。每一帧都是一张很大的`Bitmap`，每一个动画都有很多帧。Fresco让你没有这些烦恼，它处理好每一帧并管理好你的内存。
</div>
</div>
