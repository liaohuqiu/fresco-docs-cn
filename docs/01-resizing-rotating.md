---
id: resizing-rotating
title: 缩放和旋转图片
layout: docs
permalink: /docs/resizing-rotating.html
prev: listening-download-events.html
next: modifying-image.html
---

使用这个功能需要直接[创建 image request](using-controllerbuilder.html#ImageRequest)。

### 术语

**Scaling** 是一种画布操作，通常是由硬件加速的。图片实际大小保持不变，它只不过在绘制时被放大或缩小。

**Resizing** 是一种软件执行的管道操作。它返回一张新的，尺寸不同的图片。

**Downsampling** 同样是软件实现的管道操作。它不是创建一张新的图片，而是在解码时改变图片的大小。

### 应该 **resize** 还是 **scale** ？

Resize 很少是必要的。Scale 是大部分情况下的优先选择，即使在用 resize 时。

Resize 有以下几个限制：

 - 修改尺寸是受限的，它不能返回一张更大的图片，只能让图片变小。
 - 目前，只有 JPEG 图片可以修改尺寸。
 - 对于产生的图片的尺寸，只能粗略地控制。图片不能修改为确定的尺寸，只能通过支持的修改选项来变化。这意味着即使是修改后的图片，也需要在展示前进行 **scale** 操作。
 - 只支持以下的修改选项： N / 8，1 <= N <= 8
 - Resize 是由软件执行的，相比硬件加速的 scale 操作较慢。

Scale 并没有以上的限制，它使用 Android 内置的功能使图片和显示边界相符。在 Android 4.0 及之后，它可以通过 GPU 进行加速。这在大部分情况下是最快，同时也是最高效地将图片显示为你想要的尺寸的方式。唯一的缺点是当图片远大于显示大小时，会浪费内存。

那么什么时候该使用 resize 呢？你应该只在需要展示一张远大于显示大小的图片时使用 resize 以节省内存。一个例子是当你想要在 1280*720(大约 1MP) 的 view 中显示一张 8MP 的照片时。一张 8MP 的图片当解码为 4字节/像素的 ARGB 图片时大约占 32MB 的内存。如果 resize 为显示大小，它只占用少于 4MB 内存。

对于网络图片，在考虑 resize 之前，先尝试请求大小合适的图片。如果服务器能返回一张较小的图，就不要请求一张 8MP 的高解析度图片。你应该考虑用户的流量。同时，获取较小的图片可以减少你的 APP 的存储空间和 CPU 占用。

只有当服务器不提供可选的较小图片，或者你在使用本地图片时，你才应该采取 resize。在任何其他情况下，包括放大图片，都该使用 scale。对于 scale，只需要指定 `SimpleDraweeView` 中 `layout_width` 和 `layout_height` 的大小，就像在其他 Android View 中做的那样。然后指定[缩放类型](scaling.html)。

### **Resizing**

Resize 并不改变原始图片，它只在解码前修改内存中的图片大小。

相比 Android 内置的功能，这个方法可以进行更大范围的调整。尤其是通过相机拍摄的照片，对于 scale 来说通常太大，需要在显示前进行 resize。

目前仅支持 JPEG 格式图片的 resize 操作，但它是最常用的图片格式，且大多数安卓设备的相机照片存储为该格式。

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

### 向下采样(Downsampling)

向下采样是一个最近添加到 Fresco 的特性。使用的话需要在设置 image pipeline 时进行设置：

```java
   .setDownsampleEnabled(true)
```

如果开启该选项，pipeline 会向下采样你的图片，代替 resize 操作。你仍然需要像上面那样在每个图片请求中调用 `setResizeOptions` 。

向下采样在大部分情况下比 resize 更快。除了支持 JPEG 图片，它还支持 PNG 和 WebP(除动画外) 图片。

我们希望在将来的版本中默认开启此选项。

### <a name="rotate"></a>自动旋转

如果看到的图片是侧着的，用户会非常难受。许多设备会在 JPEG 文件的 metadata 中记录下照片的方向。如果你想图片呈现的方向和设备屏幕的方向一致，你可以简单地这样做到:

```java
ImageRequest request = ImageRequestBuilder.newBuilderWithSource(uri)
    .setAutoRotateEnabled(true)
    .build();
// as above
```
