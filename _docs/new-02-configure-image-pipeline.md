---
docid: configure-image-pipeline
title: 配置 Image Pipeline
layout: docs
permalink: /docs/configure-image-pipeline.html
prev: closeable-references.html
next: customizing-image-formats.html
---

对于大多数的应用，初始化 Fresco，只需一行代码:

```java
Fresco.initialize(context);
```

对于那些需要更多自定义配置的应用，我们提供了 [ImagePipelineConfig](../javadoc/reference/com/facebook/imagepipeline/core/ImagePipelineConfig.html) 类。

以下示例列出了所有可配置的选项。几乎没有应用是需要用到以下所有配置的，列出来仅仅是为了作为参考。

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

请记得将配置好的 `ImagePipelineConfig` 传递给 `Fresco.initialize`！ 否则 Fresco 仍旧是使用默认配置。

### 理解 Suppliers

许多 Builder 的配置方法都接受一个 [Supplier](../javadoc/reference/com/facebook/common/internal/Supplier.html) 类型的实例作为参数，而不是配置本身的实例。这在创建时也许有一些复杂，但这带来更多的利好：允许在 App 运行时改变配置。以内存缓存为例，每隔 5 分钟就会检查一下 Supplier。 

如果你不需要动态改变参数，那就让 Supplier 每次都返回同一个对象：

```java
Supplier<X> xSupplier = new Supplier<X>() {
  private X mX = new X(xparam1, xparam2...);
  public X get() {
    return mX;
  }
);
// 当正在创建 Image Pipeline 时
.setXSupplier(xSupplier);
```

### 线程池

Image Pipeline 默认使用了 3 个线程池：

1. 3 个线程用于网络下载
2. 2 个线程用于磁盘操作：本地文件、磁盘缓存。
3. 2 个线程用于 CPU 相关的操作：解码、转换，以及后处理等后台操作。

你能通过[设置网络层](using-other-network-layers.html) 来自定义网络的相关特性。

要改变其他操作的特性，传入一个 [ExecutorSupplier](../javadoc/reference/com/facebook/imagepipeline/core/ExecutorSupplier.html) 即可。

### 使用 MemoryTrimmableRegistry

如果你的应用监听了系统的内存事件，可以将它们传递给 Fresco 来调整内存缓存。

对大多数应用而言，最简单的监听方式就是复写 [Activity.onTrimMemory](http://developer.android.com/reference/android/app/Activity.html#onTrimMemory(int))。 你也可以使用任何 [ComponentCallbacks2](http://developer.android.com/reference/android/content/ComponentCallbacks2.html) 的子类。

你应该实现一个 [MemoryTrimmableRegistry](http://frescolib.org/javadoc/reference/com/facebook/common/memory/MemoryTrimmableRegistry.html)。它会持有一个 [MemoryTrimmable](http://frescolib.org/javadoc/reference/com/facebook/common/memory/MemoryTrimmable.html) 对象的集合 - Fresco 的缓存就在其中。当收到一个系统内存的事件时，你可以对每个可调整的（trimmables）对象调用合适的 `MemoryTrimmable` 方法。

### 配置内存缓存

位图缓存和未解码的内存缓存可以通过 [MemoryCacheParams](../javadoc/reference/com/facebook/imagepipeline/cache/MemoryCacheParams.html#MemoryCacheParams\(int, int, int, int, int\)) 对象的提供者（Supplier）来配置。

### 配置硬盘缓存

你可以使用构建者模式来创建 [DiskCacheConfig](../javadoc/reference/com/facebook/cache/disk/DiskCacheConfig.Builder.html) 对象：

```java
DiskCacheConfig diskCacheConfig = DiskCacheConfig.newBuilder()
   .set....
   .set....
   .build()

//  构建 ImagePipelineConfig
.setMainDiskCacheConfig(diskCacheConfig)
```

### 保存缓存状态

如果你想追踪缓存命中率等指标，你可以实现 [ImageCacheStatsTracker](../javadoc/reference/com/facebook/imagepipeline/cache/ImageCacheStatsTracker.html) 类。 它会为每次缓存事件提供可用于保留相关统计信息的回调。