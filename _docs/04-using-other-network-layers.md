---
docid: using-other-network-layers
title: 自定义网络加载
layout: docs
permalink: /docs/using-other-network-layers.html
prev: shared-transitions.html
next: using-other-image-loaders.html
---

Image pipeline 默认使用[HttpURLConnection](https://developer.android.com/training/basics/network-ops/connecting.html)。应用可以根据自己需求使用不同的网络库。

### OkHttp

[OkHttp](http://square.github.io/okhttp) 是一个流行的开源网络请求库。Image
pipeline有一个使用OkHttp替换掉了Android默认的网络请求的补充。

如果需要使用OkHttp,
不要使用这个[下载](download-fresco.html)页面的gradle依赖配置，应该使用下面的依赖配置

For OkHttp2:

```groovy
dependencies {
  // your project's other dependencies
  compile "com.facebook.fresco:imagepipeline-okhttp:{{site.current_version}}+"
}
```

For OkHttp3:

```groovy
dependencies {
  // your project's other dependencies
  compile "com.facebook.fresco:imagepipeline-okhttp3:{{site.current_version}}+"
}
```

#### Eclipse 中使用 OkHttp

Eclipse 用户需要依赖`frescolib`目录下的`imagepipeline-okhttp` 或 `imagepipeline-okhttp3`。 参考[在Eclipse中使用Fresco](index.html#eclipse-adt).

#### 配置 image pipeline

配置Image
pipeline这时也有一些不同，不再使用`ImagePipelineConfig.newBuilder`,而是使用`OkHttpImagePipelineConfigFactory`:

```java
Context context;
OkHttpClient okHttpClient; // build on your own
ImagePipelineConfig config = OkHttpImagePipelineConfigFactory
    .newBuilder(context, okHttpClient)
    . // other setters
    . // setNetworkFetcher is already called for you
    .build();
Fresco.initialize(context, config);
```

### 处理 Session 和 Cookie

你传给`OkHttpClient`需要处理服务器的安全校验工作（可以通过Interceptor处理）。参考[这个bug](https://github.com/facebook/fresco/issues/385) 来处理自定义网络库可能发生的 Cookie 相关的问题。

### 使用自定的网络层

为了完全控制网络层的行为，你可以自定义网络层。继承[NetworkFetchProducer](http://frescolib.org/javadoc/reference/com/facebook/imagepipeline/producers/NetworkFetchProducer.html), 这个类包含了网络通信。

你也可以选择性地继承[FetchState](http://frescolib.org/javadoc/reference/com/facebook/imagepipeline/producers/FetchState.html), 这个类是请求时的数据结构描述。

默认的 `OkHttp 3` 可以作为一个参考. 源码在这 [its source code](https://github.com/facebook/fresco/blob/master/imagepipeline-backends/imagepipeline-okhttp3/src/main/java/com/facebook/imagepipeline/backends/okhttp3/OkHttpNetworkFetcher.java)..

在[配置Image pipeline](configuring-image-pipeline.html)时，把producer传递给Image pipeline。

```java
ImagePipelineConfig config = ImagePipelineConfig.newBuilder()
  .setNetworkFetcher(myNetworkFetcher);
  . // other setters
  .build();
Fresco.initialize(context, config);
```
