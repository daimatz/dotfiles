# -*- coding: utf-8 -*-
HOST = "mamemose"

DOCUMENT_ROOT = "~/memo"

PORT = 20000
WS_PORT = 20001

MARKDOWN_PATTERN = /\.(md|markdown|txt)$/

INDEX_PATTERN = /^README\.(md|markdown|txt)$/

# RECENT_NUM = 0

RECENT_PATTERN = /\.(md|markdown|txt|key|tex|pdf)$/

host = "http://mamemose:20000"

CUSTOM_HEADER = <<HEADER
<script src="#{host}/hidden/MathJax/MathJax.js?config=TeX-AMS_HTML"></script>
<script type="text/x-mathjax-config">
MathJax.Hub.Config({
  tex2jax: {
    inlineMath: [ ['$','$'] ],
    displayMath: [ ['$$','$$'] ],
    processEscapes: true,
    skipTags: ['script', 'noscript', 'style', 'textarea', 'pre', 'code'],
    extensions: ["TeX/AMSmath.js", "TeX/AMSsymbol.js"],
  }
});
</script>
HEADER
