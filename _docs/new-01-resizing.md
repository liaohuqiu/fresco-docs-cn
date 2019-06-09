---
docid: resizing
title: 调整尺寸
layout: docs
permalink: /docs/resizing.html
redirect_from:
  - /docs/resizing-rotating.html
prev: rotation.html
next: supported-uris.html
---

本节中，我们会用到以下术语：

- **缩放** 是画布操作，并且通常使用硬件加速。位图文件本身尺寸不变，仅在绘制时放大或缩小。请参阅 [缩放类型](scaletypes.html)。
- **调整尺寸** 是由软件执行的管道操作。它会在图片解码之前改变内存中的编码图片。解码的位图将小于原始的位图。
- **向下采样** 也是由软件实现的管道操作。它不会创建一个新的编码图片，而是对一些像素的子集进行解码，从而产生较小的输出位图。

### 调整尺寸

调整尺寸不更改源文件，它仅在解码前，调整内存中编码文件的尺寸。

要调整尺寸，要在构造 `ImageRequest` 时传入 `ResizeOptions` 对象:

```java
ImageRequest request = ImageRequestBuilder.newBuilderWithSource(uri)
    .setResizeOptions(new ResizeOptions(50, 50))
    .build();
mSimpleDraweeView.setController(
    Fresco.newDraweeControllerBuilder()
        .setOldController(mSimpleDraweeView.getController())
        .setImageRequest(request)
        .build());
```

调整尺寸有一些限制：

- 它仅支持 JPEG 文件
- 实际调整的尺寸会接近原始尺寸的 1/8
- 它不能使你的图片更大，只能使之更小（虽然这不算是真正的限制）

### 向下采样

向下采样是 Fresco 最近添加的一个实验性功能。要使用它，你必须在 [配置图片管道（ImagePipeline）] 时明确地启用它：

```java
   .setDownsampleEnabled(true)
```

如果这个选项启用了，图片管道将对你的图片向下采样，而不是调整它们的尺寸。你必须在每一个图片请求上调用 `setResizeOptions`。

向下采样通常比调整尺寸更快，因为它是解码的其中一步，而不是单独的一步。同时也支持 PNG、WebP（动图除外）和 JPEG。

现在权衡的是，在 Android 4.4 (KitKat) 上，在解码时，它比调整尺寸占用更多的内存。这应该只是需要同时解码大量图片的应用程序会遇到的问题。 我们希望找到一个解决方案，并将其作为未来版本的默认设置。

### 你应该使用哪一个以及何时使用？

如果图片**不**比视图大太多，只用缩放就好了。它更快、更易编码，并且有高质量的输出。当然，图片**不**比视图大太多包含了图片小于视图的情况。因此，如果你需要放大图片，应该通过缩放来完成，而不是调整尺寸。这样，内存不会浪费在更大的位图上，而这个位图也不能提供更好的质量。
然而，对于图片比视图大太多的情况，例如**本地相机图片**，除了缩放之外，强烈建议使用调整尺寸。

至于 "大很多" 的意思，经验上来说是指图片超过视图的两倍大小（总像素数，即：宽度 * 高度），你应该使用调整尺寸。它几乎总适用于相机拍摄的本地图片。例如，一台设备的屏幕尺寸是 1080 x 1920 像素（约 2 MP），16 MP 的相机产生的图片大小比屏幕大 8 倍。毫无疑问，在这种情况下调整尺寸总是最好的选择。

对于网络图片，请尽可能地尝试下载接近显示区域尺寸的图片。下载尺寸不合适的图片就是在浪费用户的时间和数据。

如果图片比视图大，不使用调整尺寸会浪费内存。然而，还需要考虑权衡性能。

显然，调整尺寸会增加额外的 CPU 开销。但是，不对图片大于视图的图片调整尺寸，需要传输更多字节给 GPU，并且图片被频繁的从位图缓冲区取出导致更频繁的解码。换句话说，当你还可以增加 CPU 的开销时，不要调整大小。

因此，这个问题没有通解，这取决于设备的性能阀值，超过这个阀值后，使用调整大小比不使用调整大小有更好的性能。

### 例子

Fresco 示例应用中的 [ImagePipelineResizingFragment](https://github.com/facebook/fresco/blob/master/samples/showcase/src/main/java/com/facebook/fresco/samples/showcase/imagepipeline/ImagePipelineResizingFragment.java) 演示了使用占位图、失败图和重试图的例子。

![示例应用中关于调整尺寸例子的图片](/static/images/docs/01-resizing-sample.png)
