# -*- coding: utf-8 -*-
HOST = "mamemose"

DOCUMENT_ROOT = "~/memo"

PORT = 20000
WS_PORT = 20001

MARKDOWN_PATTERN = /\.(md|markdown|txt)$/

INDEX_PATTERN = /^README\.(md|markdown|txt)$/

# RECENT_NUM = 0

RECENT_PATTERN = /\.(md|markdown|txt|key|tex|pdf)$/

SYNTAX_HIGHLIGHT = :syntaxhighlighter

host = "http://mamemose:20000/hidden"

CUSTOM_HEADER = <<HEADER
<script src="#{host}/MathJax/MathJax.js?config=TeX-AMS_HTML"></script>
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

CUSTOM_FOOTER = <<FOOTER
<link href="#{host}/styles/shCoreDefault.css" rel="stylesheet" type="text/css" />
<script src="#{host}/scripts/shCore.js" type="text/javascript"></script>
<script src="#{host}/scripts/shAutoloader.js" type="text/javascript"></script>
<script type="text/javascript">
SyntaxHighlighter.autoloader(
'AS3 as3 #{host}/scripts/shBrushAS3.js',
'AppleScript applescript #{host}/scripts/shBrushAppleScript.js',
'Bash sh bash #{host}/scripts/shBrushBash.js',
'CSharp csharp #{host}/scripts/shBrushCSharp.js',
'ColdFusion coldfusion #{host}/scripts/shBrushColdFusion.js',
'Cpp c cc cpp #{host}/scripts/shBrushCpp.js',
'Css css #{host}/scripts/shBrushCss.js',
'Delphi delphi #{host}/scripts/shBrushDelphi.js',
'Diff diff #{host}/scripts/shBrushDiff.js',
'Erlang erlang #{host}/scripts/shBrushErlang.js',
'Groovy groovy #{host}/scripts/shBrushGroovy.js',
'JScript js jscript #{host}/scripts/shBrushJScript.js',
'Java java #{host}/scripts/shBrushJava.js',
'JavaFX javafx #{host}/scripts/shBrushJavaFX.js',
'Perl pl perl #{host}/scripts/shBrushPerl.js',
'Php php #{host}/scripts/shBrushPhp.js',
'Plain plain #{host}/scripts/shBrushPlain.js',
'PowerShell powershell #{host}/scripts/shBrushPowerShell.js',
'Python py python #{host}/scripts/shBrushPython.js',
'Ruby rb ruby #{host}/scripts/shBrushRuby.js',
'Sass sass #{host}/scripts/shBrushSass.js',
'Scala scala #{host}/scripts/shBrushScala.js',
'Sql sql #{host}/scripts/shBrushSql.js',
'Vb vb #{host}/scripts/shBrushVb.js',
'Xml xml html #{host}/scripts/shBrushXml.js',
'Haskell haskell hs #{host}/scripts/shBrushHaskell.js'
);
SyntaxHighlighter.all();
</script>
FOOTER
