---
docid: prefetching
title: 预加载图片
layout: docs
permalink: /docs/prefetching.html
prev: listening-to-events.html
next: modifying-image.html
---

在显示图片之前预加载图片可缩短用户等待的时间。但是，请记得权衡其中的利弊。预加载要消耗用户的流量、占用 CPU 和内存。通常，对大多数应用都不建议使用预加载。

尽管如此，图片管道允许你预加载到磁盘或位图缓存。两者都将对网络 URI 使用额外的数据流量，但磁盘缓存不会进行解码，因而占用更少的 CPU。

__注意：__ 如果你的网络请求不支持优先级，预加载请求也许会减慢那些需要立即显示在屏幕上的图片的加载速度。`OkHttpNetworkFetcher` 和 `HttpUrlConnectionNetworkFetcher` 目前都不支持优先级。

预加载到磁盘：

```java
imagePipeline.prefetchToDiskCache(imageRequest, callerContext);
```

预加载到位图缓存中： 

```java
imagePipeline.prefetchToBitmapCache(imageRequest, callerContext);
```

取消预加载：

```java
// 持有返回的数据的引用。
DataSource<Void> prefetchDataSource = imagePipeline.prefetchTo...;

// 然后，如果你需要取消预加载：
prefetchDataSource.close();
```

取消一个已经预加载好的数据源是无效的，不过如果你一定要这么做，也不会发生问题。

### 示例

请参考我们的 [示例 App](https://github.com/facebook/fresco/blob/master/samples/showcase/src/main/java/com/facebook/fresco/samples/showcase/imagepipeline/ImagePipelinePrefetchFragment.java) 中一个关于如何使用预加载的例子。
