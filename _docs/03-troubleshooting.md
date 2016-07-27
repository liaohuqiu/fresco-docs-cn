---
docid: troubleshooting
title: 问题处理
layout: docs
permalink: /docs/troubleshooting.html
prev: closeable-references.html
next: gotchas.html
---

### 重复的边界

这是使用圆角的一个缺陷。 参考[圆角和圆圈](rounded-corners-and-circles.html) 来获取更多信息。

### 图片没有加载

你可以从 image pipeline 打出的[日志](#logcat)来查看原因。 这里提供一些通常会导致问题的原因:

#### 文件不可用

无效的路径、链接会导致这种情况。

判断网络链接是否有效，你可以尝试在浏览器中打开它，看看是否图片会被加载。若图片依然加载不出来，那么这不是Fresco的问题。

判断本地文件是否有效，你可以通过下面这段代码来校验：

```
FileInputStream fis = new FileInputStream(new File(localUri.getPath()));
```

如果这里抛出了异常，那么这不是Fresco的问题，可能是你的其他代码导致的。有可能是没有获取到SD卡读取权限、路径不合法、文件不存在等。

#### OOM - 无法分配图片空间

加载特别特别大的图片时最容易导致这种情况。如果你加载的图片比承载的View明显大出太多，那你应该考虑将它[Resize](resizing-rotating.html#_)一下。

#### Bitmap太大导致无法绘制

Android 无法绘制长或宽大于2048像素的图片。这是由OpenGL渲染系统限制的，如果它超过了这个界限，Fresco会对它进行[Resize](resizing-rotating.html#_)。

### <a name='logcat'></a> 通过Logcat来判断原因

在加载图片时会出现各种各样的原因导致加载失败。 在使用Fresco的时候，最直接的方式就是查看 image pipeline 打出的`VERBOSE`级别日志。

#### 启动日志

默认情况下Fresco是关闭日志输出的，你可以[配置image pipeline](configure-image-pipeline.html#_)让它启动.

```java
Set<RequestListener> requestListeners = new HashSet<>();
requestListeners.add(new RequestLoggingListener());
ImagePipelineConfig config = ImagePipelineConfig.newBuilder(context)
   // other setters
   .setRequestListeners(requestListeners)
   .build();
Fresco.initialize(context, config);
FLog.setMinimumLoggingLevel(FLog.VERBOSE);
```

#### 查看日志

你可以通过下面这条shell命令来查看Fresco日志：

```
adb logcat -v threadtime | grep -iE 'LoggingListener|AbstractDraweeController|BufferedDiskCache'
```

它的输出为如下格式：

```
08-12 09:11:14.791 6690 6690 V unknown:AbstractDraweeController: controller 28ebe0eb 0 -> 1: initialize
08-12 09:11:14.791 6690 6690 V unknown:AbstractDraweeController: controller 28ebe0eb 1: onDetach
08-12 09:11:14.791 6690 6690 V unknown:AbstractDraweeController: controller 28ebe0eb 1: setHierarchy: null
08-12 09:11:14.791 6690 6690 V unknown:AbstractDraweeController: controller 28ebe0eb 1: setHierarchy: com.facebook.drawee.generic.GenericDraweeHierarchy@2bb88e4
08-12 09:11:14.791 6690 6690 V unknown:AbstractDraweeController: controller 28ebe0eb 1: onAttach: request needs submit
08-12 09:11:14.791 6690 6690 V unknown:PipelineDraweeController: controller 28ebe0eb: getDataSource
08-12 09:11:14.791 6690 6690 V unknown:RequestLoggingListener: time 11201791: onRequestSubmit: {requestId: 1, callerContext: null, isPrefetch: false}
08-12 09:11:14.792 6690 6690 V unknown:RequestLoggingListener: time 11201791: onProducerStart: {requestId: 1, producer: BitmapMemoryCacheGetProducer}
08-12 09:11:14.792 6690 6690 V unknown:RequestLoggingListener: time 11201792: onProducerFinishWithSuccess: {requestId: 1, producer: BitmapMemoryCacheGetProducer, elapsedTime: 1 ms, extraMap: {cached_value_found=false}}
08-12 09:11:14.792 6690 6690 V unknown:RequestLoggingListener: time 11201792: onProducerStart: {requestId: 1, producer: BackgroundThreadHandoffProducer}
08-12 09:11:14.792 6690 6690 V unknown:AbstractDraweeController: controller 28ebe0eb 1: submitRequest: dataSource: 36e95857
08-12 09:11:14.792 6690 6734 V unknown:RequestLoggingListener: time 11201792: onProducerFinishWithSuccess: {requestId: 1, producer: BackgroundThreadHandoffProducer, elapsedTime: 0 ms, extraMap: null}
08-12 09:11:14.792 6690 6734 V unknown:RequestLoggingListener: time 11201792: onProducerStart: {requestId: 1, producer: BitmapMemoryCacheProducer}
08-12 09:11:14.792 6690 6734 V unknown:RequestLoggingListener: time 11201792: onProducerFinishWithSuccess: {requestId: 1, producer: BitmapMemoryCacheProducer, elapsedTime: 0 ms, extraMap: {cached_value_found=false}}
08-12 09:11:14.792 6690 6734 V unknown:RequestLoggingListener: time 11201792: onProducerStart: {requestId: 1, producer: EncodedMemoryCacheProducer}
08-12 09:11:14.792 6690 6734 V unknown:RequestLoggingListener: time 11201792: onProducerFinishWithSuccess: {requestId: 1, producer: EncodedMemoryCacheProducer, elapsedTime: 0 ms, extraMap: {cached_value_found=false}}
08-12 09:11:14.792 6690 6734 V unknown:RequestLoggingListener: time 11201792: onProducerStart: {requestId: 1, producer: DiskCacheProducer}
08-12 09:11:14.792 6690 6735 V unknown:BufferedDiskCache: Did not find image for http://www.example.com/image.jpg in staging area
08-12 09:11:14.793 6690 6735 V unknown:BufferedDiskCache: Disk cache read for http://www.example.com/image.jpg
08-12 09:11:14.793 6690 6735 V unknown:BufferedDiskCache: Disk cache miss for http://www.example.com/image.jpg
08-12 09:11:14.793 6690 6735 V unknown:RequestLoggingListener: time 11201793: onProducerFinishWithSuccess: {requestId: 1, producer: DiskCacheProducer, elapsedTime: 1 ms, extraMap: {cached_value_found=false}}
08-12 09:11:14.793 6690 6735 V unknown:RequestLoggingListener: time 11201793: onProducerStart: {requestId: 1, producer: NetworkFetchProducer}
08-12 09:11:15.161 6690 7358 V unknown:RequestLoggingListener: time 11202161: onProducerFinishWithSuccess: {requestId: 1, producer: NetworkFetchProducer, elapsedTime: 368 ms, extraMap: null}
08-12 09:11:15.162 6690 6742 V unknown:BufferedDiskCache: About to write to disk-cache for key http://www.example.com/image.jpg
08-12 09:11:15.162 6690 6734 V unknown:RequestLoggingListener: time 11202162: onProducerStart: {requestId: 1, producer: DecodeProducer}
08-12 09:11:15.163 6690 6742 V unknown:BufferedDiskCache: Successful disk-cache write for key http://www.example.com/image.jpg
08-12 09:11:15.169 6690 6734 V unknown:RequestLoggingListener: time 11202169: onProducerFinishWithSuccess: {requestId: 1, producer: DecodeProducer, elapsedTime: 7 ms, extraMap: {hasGoodQuality=true, queueTime=0, bitmapSize=600x400, isFinal=true}}
08-12 09:11:15.169 6690 6734 V unknown:RequestLoggingListener: time 11202169: onRequestSuccess: {requestId: 1, elapsedTime: 378 ms}
08-12 09:11:15.184 6690 6690 V unknown:AbstractDraweeController: controller 28ebe0eb 1: set_final_result @ onNewResult: image: CloseableReference 2fd41bb0
```

在这个示例中，我们发现名为`28ebe0eb`的 DraweeView 向名为`36e95857`的 DataSource 进行了图像请求。首先，图片没有在内存缓存中找到，也没有在磁盘缓存中找到，最后去网络上下载图片。下载成功后，图片被解码，之后请求结束。最后数据源通知 controller 图片就绪，显示图片(`set_final_result`）。
