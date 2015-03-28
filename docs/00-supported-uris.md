---
id: supported-uris
title: 支持的URIs
layout: docs
permalink: /docs/supported-uris.html
prev: concepts.html
next: using-drawees-xml.html
---

Fresco 支持许多URI格式。

特别注意：Fresco **不支持** 相对路径的URI. 所有的URI都必须是绝对路径，并且带上该URI的scheme。

如下：


| 类型 | Scheme | 示例 |
| ---------------- | ------- | ------------- |
| 远程图片 | `http://,` `https://` | `HttpURLConnection` 或者参考 [使用其他网络加载方案](using-other-network-layers.html) |
| 本地文件 | `file://` | `FileInputStream` | 
| Content provider | `content://` | `ContentResolver` |
| asset目录下的资源 | `asset://` | `AssetManager` |
| res目录下的资源 | `res://` | `Resources.openRawResource` |
