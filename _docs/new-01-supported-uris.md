---
docid: supported-uris
title: 支持的 URI
layout: docs
permalink: /docs/supported-uris.html
prev: resizing.html
next: caching.html
---

Fresco 支持多种图片定位。Fresco **不支持** 相对路径的 URI。所有的 URI 必须是绝对路径，并且必须包含该 URI 对应的 scheme。

支持的 URI scheme 如下：

| 类型 | Scheme | 示例
| ---------------- | ------- | ------------- |
| 远程文件 | `http://,` `https://` | `HttpURLConnection` 或 [其他网络加载方案](using-other-network-layers.html) |
| 本地文件 | `file://` | `FileInputStream` |
| Content Provider | `content://` | `ContentResolver` |
| asset 目录下的资源文件 | `asset://` | `AssetManager` |
| res 目录下的资源文件 | `res://`, 如 `res:///12345` | `Resources.openRawResource` |
| 含有 Data 信息的 URI | `data:mime/type;base64,` | 遵循 [URI 数据规范](http://tools.ietf.org/html/rfc2397) (仅支持 UTF-8) |

<br/>
注意：只有图片资源才能在 Image Pipeline 中使用，比如（PNG）。其他资源类型，比如字符串，或者 XML 类型的 drawable 在 Image Pipeline 中没有意义，所以不支持加载这些类型的资源。一个可能令人困惑的情况是使用 XML 声明的 drawable（例如 ShapeDrawable）。重点在于要注意它**不是**图片。如果你想要显示一个 XML 类型的 drawable 作为主图片，则将其设为 [占位图](placeholder-failure-retry.html) 并使用 `null` 的 URI 对象。

### 例子：加载 URI

在示例应用中的 `DraweeSimpleFragment` 有一个仅加载 URI 的例子: [DraweeSimpleFragment.java](https://github.com/facebook/fresco/blob/master/samples/showcase/src/main/java/com/facebook/fresco/samples/showcase/drawee/DraweeSimpleFragment.java)

![加载 URI 的简单示例](/static/images/docs/01-using-simpledraweeview-sample.png)

### 例子：加载本地文件

在示例应用的 `DraweeMediaPickerFragment` 中有一个关于如何正确加载用户所选文件（使用 scheme 为 `content://` 的 URI）的例子: [DraweeMediaPickerFragment.java](https://github.com/facebook/fresco/blob/master/samples/showcase/src/main/java/com/facebook/fresco/samples/showcase/drawee/DraweeMediaPickerFragment.java)

![加载本地文件的示例](/static/images/docs/01-supported-uris-sample-local-file.png)

### 例子：加载含有 Data 信息的 URI

示例应用中的 [ImageFormatDataUriFragment](https://github.com/facebook/fresco/blob/master/samples/showcase/src/main/java/com/facebook/fresco/samples/showcase/imageformat/datauri/ImageFormatDataUriFragment.java) 演示了关于占位图，失败图和重试图的使用。

![加载含有 Data 信息的 URI 的示例](/static/images/docs/01-supported-uris-sample-data-uri.png)

### 更多

**提示：** 你能通过在全局设置中使用 *URI Override* 选项复写示例应用的众多示例中所展示的图片的 URI。

![URI 复写设置](/static/images/docs/01-supported-uris-sample-override.png)