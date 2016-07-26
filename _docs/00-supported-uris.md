---
docid: supported-uris
title: 支持的URI
layout: docs
permalink: /docs/supported-uris.html
prev: concepts.html
next: using-drawees-xml.html
---


Fresco 支持许多URI格式。

特别注意：Fresco **不支持** 相对路径的URI. 所有的 URI 都必须是绝对路径，并且带上该 URI 的 scheme。

如下：


| 类型 | Scheme | 示例 |
| ---------------- | ------- | ------------- |
| 远程图片 | `http://,` `https://` | `HttpURLConnection` 或者参考 [使用其他网络加载方案](using-other-network-layers.html) |
| 本地文件 | `file://` | `FileInputStream` | 
| Content provider | `content://` | `ContentResolver` |
| asset目录下的资源 | `asset://` | `AssetManager` |
| res目录下的资源 | `res://` | `Resources.openRawResource` |
| Uri中指定图片数据 | `data:mime/type;base64,` | 数据类型必须符合 [rfc2397规定](http://tools.ietf.org/html/rfc2397) (仅支持 UTF-8) |

res 示例:

```
Uri uri = Uri.parse("res://包名(实际可以是任何字符串甚至留空)/" + R.drawable.ic_launcher);
```

<br/>
注意，只有图片资源才能使用在Image
pipeline中，比如(PNG)。其他资源类型，比如字符串，或者XML Drawable在Image
pipeline中没有意义。所以加载的资源不支持这些类型。

像`ShapeDrawable`这样声明在XML中的drawable可能引起困惑。注意到这毕竟不是图片。如果想把这样的drawable作为图像显示，那么把这个drawable设置为占位图，然后把URI设置为`null`。
