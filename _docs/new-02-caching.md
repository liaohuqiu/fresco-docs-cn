---
docid: caching
title: Caching
layout: docs
permalink: /docs/caching.html
prev: supported-uris.html
next: closeable-references.html
---

Fresco 将图片存储在三种不同类型的缓存中，它们的构成是有层级的，检索图像的成本随着层级的深入而增加。

#### 1. 位图缓存

位图缓存是将解码后的图片存到 Android 的 `Bitmap` 对象中。它们已经可以显示或进行[后处理](modifying-image.html)。

在 Android 5.0 以下的版本中，位图缓存的数据存在于 *ashmem* 堆中，而不是 Java 堆中。这意味着图像不会额外触发垃圾回收器，因此不会减慢应用程序的运行速度。

Android 5.0 及其以上版本的内存管理机制比之前版本有很大提高，因此将位图缓存放在 Java 堆中会更安全。

当你的应用退到后台时，你应该[清空缓存](#clearing-the-cache)。

#### 2. 编码过的内存缓存

此缓存以原始压缩格式存储图像。 从这个缓存中检索到的图像必须解码后才能显示。

如果有其他的变换，例如[调整尺寸](resizing.html)、[旋转](rotation.html) 或[转码](#webp)，则会在解码之前进行。

#### 3. 磁盘缓存

（没错，我们知道手机没有磁盘，但是将它称为*本地存储缓存*实在太长了...）

和编码过的内存缓存一样，它也存储着被压缩过的图片，也需要在显示前先解码，并且有时要先变换。

和其他缓存不一样的是，这个缓存在应用退出时不会被清空，甚至在手机关机时也不会清空。

当磁盘缓存达到 [DiskCacheConfig](configure-image-pipeline.html#configuring-the-disk-cache) 定义的上限时，Fresco 使用 LRU 的逻辑回收磁盘缓存（详见 [DefaultEntryEvictionComparatorSupplier.java](https://github.com/facebook/fresco/blob/master/imagepipeline-base/src/main/java/com/facebook/cache/disk/DefaultEntryEvictionComparatorSupplier.java)）。

当然，用户总是能从 Android 的设置菜单中清空它。

### 检查某张图片是否在缓存中

你可以使用 [ImagePipeline](../javadoc/reference/com/facebook/imagepipeline/core/ImagePipeline.html) 中的方法来查看某张图片是否在缓存中。检查内存缓存的操作是同步进行的：

```java
ImagePipeline imagePipeline = Fresco.getImagePipeline();
Uri uri;
boolean inMemoryCache = imagePipeline.isInBitmapMemoryCache(uri);
```

检查磁盘缓存的操作是异步进行的，因为磁盘检查必须在另一个线程中完成。你可以像这样调用它：

```java
DataSource<Boolean> inDiskCacheSource = imagePipeline.isInDiskCache(uri);
DataSubscriber<Boolean> subscriber = new BaseDataSubscriber<Boolean>() {
    @Override
    protected void onNewResultImpl(DataSource<Boolean> dataSource) {
      if (!dataSource.isFinished()) {
        return;
      }
      boolean isInCache = dataSource.getResult();
      // your code here
    }
  };
inDiskCacheSource.subscribe(subscriber, executor);
```

这里假设你使用的是默认的缓存键工厂。如果你自定义了一个，你可能需要使用带有 `ImageRequest` 参数的方法。

### 丢弃缓存

[ImagePipeline](../javadoc/reference/com/facebook/imagepipeline/core/ImagePipeline.html) 也有一些方法能从缓存中单独丢弃对应的缓存：

```java
ImagePipeline imagePipeline = Fresco.getImagePipeline();
Uri uri;
imagePipeline.evictFromMemoryCache(uri);
imagePipeline.evictFromDiskCache(uri);

// 上面两行的组合
imagePipeline.evictFromCache(uri);
```

如上所示, `evictFromDiskCache(Uri)` 假设你使用的是默认的缓存键工厂。使用了自定义工厂的用户则要用 `evictFromDiskCache(ImageRequest)`。

### 清空缓存

```java
ImagePipeline imagePipeline = Fresco.getImagePipeline();
imagePipeline.clearMemoryCaches();
imagePipeline.clearDiskCaches();

// 上面两行的组合
imagePipeline.clearCaches();
```

### 使用一个或两个磁盘缓存？

大多数的应用只需要一个磁盘缓存。但在某些情况下，你也许想将小图放到一个独立的缓存中，以防止它们被较大的图片过早地从缓存中驱逐出去。

为此，只需要在[配置 ImagePipeline](configure-image-pipeline.html) 时同时调用 `setMainDiskCacheConfig` 和 `setSmallImageDiskCacheConfig` 方法即可。

怎么定义*小*呢？你的应用已经搞定了。当[设置图片请求](image-requests.html)时，你也设置了它的 [CacheChoice](../javadoc/reference/com/facebook/imagepipeline/request/ImageRequest.CacheChoice.html)：

```java
ImageRequest request = ImageRequestBuilder.newBuilderWithSource(uri)
    .setCacheChoice(ImageRequest.CacheChoice.SMALL)
```

如果你只需要一个缓存，则不必调用 `setSmallImageDiskCacheConfig`。管道将默认使用同一个缓存，并且 `CacheChoice` 会被忽略。

### 修剪内存

当配置了 [configuring](configure-image-pipeline.html) 图片管道后，你能够设置每个缓存的最大值。但有时会比你设置的低一些。例如，你的应用还有其他需要更多空间的缓存，它们会挤压 Fresco 的缓存空间。或者你可能正在检查整个设备是否用完了存储空间。

Fresco 的缓存实现了 [DiskTrimmable](../javadoc/reference/com/facebook/common/disk/DiskTrimmable.html) 或 [MemoryTrimmable](../javadoc/reference/com/facebook/common/memory/MemoryTrimmable.html) 接口。它们是需要紧急修剪时，告知你的应用的钩子。

你的应用可以使用实现了 [DiskTrimmableRegistry](../javadoc/reference/com/facebook/common/disk/DiskTrimmableRegistry.html) 和 [MemoryTrimmableRegistry](../javadoc/reference/com/facebook/common/memory/MemoryTrimmableRegistry.html) 接口的对象来配置管道。

这些对象必须持有可修剪的对象列表。它们必须使用应用特定的逻辑来决定什么时候必须保留内存或磁盘空间，然后通知可修建的对象修剪它们的缓存。
