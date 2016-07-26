---
docid: requesting-multiple-images
title: 多图请求及图片复用
layout: docs
permalink: /docs/requesting-multiple-images.html
prev: animations.html
next: listening-download-events.html
---

多图请求需要 [自定义ImageRequest](using-controllerbuilder.html).

## 先显示低分辨率的图，然后是高分辨率的图

假设你要显示一张高分辨率的图，但是这张图下载比较耗时。与其一直显示占位图，你可能想要先下载一个较小的缩略图。

这时，你可以设置两个图片的URI，一个是低分辨率的缩略图，一个是高分辨率的图。

```java
Uri lowResUri, highResUri;
DraweeController controller = Fresco.newDraweeControllerBuilder()
    .setLowResImageRequest(ImageRequest.fromUri(lowResUri))
    .setImageRequest(ImageRequest.fromUri(highResUri))
    .setOldController(mSimpleDraweeView.getController())
    .build();
mSimpleDraweeView.setController(controller);
```

动图无法在低分辨率那一层显示。

### 缩略图预览

*本功能仅支持本地URI，并且是JPEG图片格式*

如果本地JPEG图，有EXIF的缩略图，image pipeline 可以立刻返回它作为一个缩略图。`Drawee` 会先显示缩略图，完整的清晰大图在 decode 完之后再显示。

```java
Uri uri;
ImageRequest request = ImageRequestBuilder.newBuilderWithSource(uri)
    .setLocalThumbnailPreviewsEnabled(true)
    .build();

DraweeController controller = Fresco.newDraweeControllerBuilder()
    .setImageRequest(request)
    .setOldController(mSimpleDraweeView.getController())
    .build();
mSimpleDraweeView.setController(controller);
```

### 加载最先可用的图片

大部分时候，一张图片只有一个 URI。加载它，然后工作完成～

但是假设同一张图片有多个 URI 的情况。比如，你可能上传过一张拍摄的照片。原始图片太大而不能上传，所以图片首先经过了压缩。在这种情况下，首先尝试获取本地压缩后的图片 URI，如果失败的话，尝试获取本地原始图片 URI，如果还是失败的话，尝试获取上传到网络的图片 URI。直接下载我们本地可能已经有了的图片不是一件光彩的事。

Image pipeline 会首先从内存中搜寻图片，然后是磁盘缓存，再然后是网络或其他来源。对于多张图片，不是一张一张按上面的过程去做，而是 pipeline 先检查所有图片是否在内存。只有没在内存被搜寻到的才会寻找磁盘缓存。还没有被搜寻到的，才会进行一个外部请求。

使用时，创建一个image request 数组，然后传给 `ControllerBuilder` :

```java
Uri uri1, uri2;
ImageRequest request = ImageRequest.fromUri(uri1);
ImageRequest request2 = ImageRequest.fromUri(uri2);
ImageRequest[] requests = { request1, request2 };

DraweeController controller = Fresco.newDraweeControllerBuilder()
    .setFirstAvailableImageRequests(requests)
    .setOldController(mSimpleDraweeView.getController())
    .build();
mSimpleDraweeView.setController(controller);
```

这些请求中只有一个会被展示。第一个被发现的，无论是在内存，磁盘或者网络，都会是被返回的那个。pipeline 认为数组中请求的顺序即为优先顺序。

### 自定义 `DataSource Supplier`

为了更好的灵活性，你可以在创建 `Drawee controller` 时自定义 `DataSource Supplier`。你可以以 `FirstAvailiableDataSourceSupplier`,`IncreasingQualityDataSourceSupplier`为例自己实现 `DataSource Supplier`，或者以`AbstractDraweeControllerBuilder`为例将多个 `DataSource Supplier` 根据需求组合在一起。

