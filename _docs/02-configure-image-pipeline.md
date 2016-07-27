---
docid: configure-image-pipeline
title: 配置Image Pipeline
layout: docs
permalink: /docs/configure-image-pipeline.html
prev: intro-image-pipeline.html
next: caching.html
---

对于大多数的应用，Fresco的初始化，只需要以下一句代码:

```java
Fresco.initialize(context);
```

对于那些需要更多进一步配置的应用，我们提供了[ImagePipelineConfig](http://frescolib.org/javadoc/reference/com/facebook/imagepipeline/core/ImagePipelineConfig.html)。

以下是一个示例配置，列出了所有可配置的选项。几乎没有应用是需要以下这所有的配置的，列出来仅仅是为了作为参考。

```java
ImagePipelineConfig config = ImagePipelineConfig.newBuilder(context)
    .setBitmapMemoryCacheParamsSupplier(bitmapCacheParamsSupplier)
    .setCacheKeyFactory(cacheKeyFactory)
    .setDownsampleEnabled(true)
    .setWebpSupportEnabled(true)
    .setEncodedMemoryCacheParamsSupplier(encodedCacheParamsSupplier)
    .setExecutorSupplier(executorSupplier)
    .setImageCacheStatsTracker(imageCacheStatsTracker)
    .setMainDiskCacheConfig(mainDiskCacheConfig)
    .setMemoryTrimmableRegistry(memoryTrimmableRegistry)
    .setNetworkFetchProducer(networkFetchProducer)
    .setPoolFactory(poolFactory)
    .setProgressiveJpegConfig(progressiveJpegConfig)
    .setRequestListeners(requestListeners)
    .setSmallImageDiskCacheConfig(smallImageDiskCacheConfig)
    .build();
Fresco.initialize(context, config);
```

请记得将配置好的`ImagePipelineConfig` 传递给 `Fresco.initialize`! 否则仍旧是默认配置。

### 关于Supplier

许多配置的Builder都接受一个[Supplier](http://frescolib.org/javadoc/reference/com/facebook/common/internal/Supplier.html) 类型的参数而不是一个配置的实例。

创建时也许有一些麻烦，但这带来更多的利好：这允许在运行时改变创建行为。以内存缓存为例，每隔5分钟就可检查一下Supplier，根据实际情况返回不同类型。

如果你需要动态改变参数，那就是用Supplier每次都返回同一个对象。

```java
Supplier<X> xSupplier = new Supplier<X>() {
  private X mX = new X(xparam1, xparam2...);
  public X get() {
    return mX;
  }
);
// when creating image pipeline
.setXSupplier(xSupplier);
```

### 线程池

Image pipeline 默认有3个线程池:

1. 3个线程用于网络下载
2. 2个线程用于磁盘操作: 本地文件的读取，磁盘缓存操作。
3. 2个线程用于CPU相关的操作: 解码，转换，以及后处理等后台操作。

对于网络下载，你可以定制网络层的操作，具体参考:[自定义网络层加载](using-other-network-layers.html).

对于其他操作，如果要改变他们的行为，传入一个[ExecutorSupplier](http://frescolib.org/javadoc/reference/com/facebook/imagepipeline/core/ExecutorSupplier.html)即可。

### 内存策略

你的App会监听系统的内存事件，你可以让它们交由Fresco处理。

最简单的事情就是重写[Activity.onTrimMemory](http://developer.android.com/reference/android/app/Activity.html#onTrimMemory(int))函数，或者使用[ComponentCallbacks2](http://developer.android.com/reference/android/content/ComponentCallbacks2.html)。

你需要实现一个[MemoryTrimmableRegistry](http://frescolib.org/javadoc/reference/com/facebook/common/memory/MemoryTrimmableRegistry.html)，它持有一个[MemoryTrimmable](http://frescolib.org/javadoc/reference/com/facebook/common/memory/MemoryTrimmable.html)的集合。Fresco的缓存就在它们中间。当你接受到一个系统的内存事件时，你可以调用`MemoryTrimmable`的对应方法来释放资源。

### 内存缓存的配置

内存缓存和未解码的内存缓存的配置由一个Supplier控制，这个Supplier返回一个[MemoryCacheParams](http://frescolib.org/javadoc/reference/com/facebook/imagepipeline/cache/MemoryCacheParams.html#MemoryCacheParams\(int, int, int, int, int\)) 对象用于内存状态控制。

### 配置磁盘缓存

你可使用Builder模式创建一个 [DiskCacheConfig](http://frescolib.org/javadoc/reference/com/facebook/cache/disk/DiskCacheConfig.Builder.html):

```java
DiskCacheConfig diskCacheConfig = DiskCacheConfig.newBuilder()
   .set....
   .set....
   .build()

// when building ImagePipelineConfig
.setMainDiskCacheConfig(diskCacheConfig)
```

### 缓存统计

如果你想统计缓存的命中率，你可以实现[ImageCacheStatsTracker](http://frescolib.org/javadoc/reference/com/facebook/imagepipeline/cache/ImageCacheStatsTracker.html), 在这个类中，每个缓存时间都有回调通知，基于这些事件，可以实现缓存的计数和统计。
