---
docid: resizing-rotating
title: 缩放和旋转图片
layout: docs
permalink: /docs/resizing-rotating.html
prev: listening-download-events.html
next: modifying-image.html
---

使用这个功能需要直接[创建 image request](using-controllerbuilder.html#ImageRequest)。

## 术语

**Scaling** 是一种画布操作，通常是由硬件加速的。图片实际大小保持不变，它只不过在绘制时被放大或缩小。

**Resizing** 是一种软件执行的管道操作。它返回一张新的，尺寸不同的图片。

**Downsampling** 同样是软件实现的管道操作。它不是创建一张新的图片，而是在解码时改变图片的大小。

## 应该使用哪种 ？

如果图片不是比 `View` 大出很多的情况下，只需要做 **Scaling**。 它更快，更容易书写代码，并且输出的图像质量更好。当然，图片比 `View`小的情况也是这样，这样你放大图片时，不会因为产生一张新的大图而浪费内存空间，却又没有带来更好的视觉提高。

“大出很多”的定义是：

> 图片的像素数 > 视图量级x 2

* 视图量级 = 长 x 宽 *

这在大部分的照相机拍摄图片下是符合的。假设你的设备屏幕尺寸是1080 x 1920 （大概2MP），那么一个16MP的照相机产生的相片比屏幕尺寸量级大8倍。此时毫无疑问要选择 **Resize**。

对于网络图片，在考虑 resize 之前，先尝试请求大小合适的图片。如果服务器能返回一张较小的图，就不要请求一张高解析度图片。你应该考虑用户的流量。同时，获取较小的图片可以减少你的 APP 的存储空间和 CPU 占用。

### Scaling

对于 scale，只需要指定 `SimpleDraweeView` 中 `layout_width` 和 `layout_height` 的大小，就像在其他 Android View 中做的那样。然后指定[缩放类型](scaling.html)。

Scaling 使用 Android 自身的机制来缩放图片。 在 Android 4.0 及以后，在配置 GPU 的设备上会启用硬件加速。

### Resizing

Resize 并不改变原始图片，它只在解码前修改内存中的图片大小。

如果要 resize，创建`ImageRequest`时，提供一个 [ResizeOptions](../javadoc/reference/com/facebook/imagepipeline/common/ResizeOptions.html) :

```java
Uri uri = "file:///mnt/sdcard/MyApp/myfile.jpg";
int width = 50, height = 50;
ImageRequest request = ImageRequestBuilder.newBuilderWithSource(uri)
    .setResizeOptions(new ResizeOptions(width, height))
    .build();
PipelineDraweeController controller = Fresco.newDraweeControllerBuilder()
    .setOldController(mDraweeView.getController())
    .setImageRequest(request)
    .build();
mSimpleDraweeView.setController(controller);
```
Resize 有以下几个限制：

 - 目前，只有 JPEG 图片可以修改尺寸。
 - 对于产生的图片的尺寸，只能粗略地控制。图片不能修改为确定的尺寸，只能通过支持的修改选项来变化。这意味着即使是修改后的图片，也需要在展示前进行 **scale** 操作。
 - 只支持以下的修改选项： N / 8，1 <= N <= 8
 - Resize 是由软件执行的，相比硬件加速的 scale 操作较慢。

- 
- the actual resize is carried out to the nearest 1/8 of the original size
- it cannot make your image bigger, only smaller (not a real limitation though)

### 向下采样(Downsampling)

向下采样是一个正在实验中的特性。使用的话需要在设置 image pipeline 时进行[设置](configure-image-pipeline.html#_)：

```java
   .setDownsampleEnabled(true)
```

如果开启该选项，pipeline 会向下采样你的图片，代替 resize 操作。你仍然需要像上面那样在每个图片请求中调用 `setResizeOptions` 。

向下采样在大部分情况下比 resize 更快。除了支持 JPEG 图片，它还支持 PNG 和 WebP(除动画外) 图片。

但是目前还有一个问题是它在 Android 4.4 上会在解码时造成更多的内存开销（相比于Resizing）。这在同时解码许多大图时会非常显著，我们希望在将来的版本中能够解决它并默认开启此选项。

### <a name="rotate"></a>自动旋转

如果看到的图片是侧着的，用户会非常难受。许多设备会在 JPEG 文件的 metadata 中记录下照片的方向。如果你想图片呈现的方向和设备屏幕的方向一致，你可以简单地这样做到:

```java
ImageRequest request = ImageRequestBuilder.newBuilderWithSource(uri)
    .setAutoRotateEnabled(true)
    .build();
// as above
```
