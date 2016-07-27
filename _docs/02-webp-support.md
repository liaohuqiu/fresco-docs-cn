---
docid: webp-support
title: Webp支持
layout: docs
permalink: /docs/webp-support.html
prev: closeable-references.html
next: troubleshooting.html
---

Android 系统在 4.0 版本中添加入了 WebP 的支持，并在 4.2.1 版本中加强了它:

* 4.0+ (Ice Cream Sandwich): 基础的 WebP 支持
* 4.2.1+ (Jelly Beam MR1): 支持带透明度与无损的 WebP

Fresco 默认使用系统的 WebP 方案来加载它。

但同时，Fresco 能够让你在更老的版本中使用 WebP，所以如果你想要在 Android 2.3 版本的设备上使用 WebP， 你需要做的就是在工程中添加一个 `webpsupport`的依赖：

```
dependencies {
  // your app's other dependencies
  compile 'com.facebook.fresco:webpsupport:{{site.current_version}}'
}
```
