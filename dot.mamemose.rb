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
<script src="#{host}/syntaxhighlighter/scripts/shCore.js" type="text/javascript"></script>
<script src="#{host}/syntaxhighlighter/scripts/shAutoloader.js" type="text/javascript"></script>
<script type="text/javascript">
SyntaxHighlighter.autoloader(
'AS3 as3 #{host}/syntaxhighlighter/scripts/shBrushAS3.js',
'AppleScript applescript #{host}/syntaxhighlighter/scripts/shBrushAppleScript.js',
'Bash sh bash #{host}/syntaxhighlighter/scripts/shBrushBash.js',
'CSharp csharp #{host}/syntaxhighlighter/scripts/shBrushCSharp.js',
'ColdFusion coldfusion #{host}/syntaxhighlighter/scripts/shBrushColdFusion.js',
'Cpp c cc cpp #{host}/syntaxhighlighter/scripts/shBrushCpp.js',
'Css css #{host}/syntaxhighlighter/scripts/shBrushCss.js',
'Delphi delphi #{host}/syntaxhighlighter/scripts/shBrushDelphi.js',
'Diff diff #{host}/syntaxhighlighter/scripts/shBrushDiff.js',
'Erlang erlang #{host}/syntaxhighlighter/scripts/shBrushErlang.js',
'Groovy groovy #{host}/syntaxhighlighter/scripts/shBrushGroovy.js',
'JScript js jscript #{host}/syntaxhighlighter/scripts/shBrushJScript.js',
'Java java #{host}/syntaxhighlighter/scripts/shBrushJava.js',
'JavaFX javafx #{host}/syntaxhighlighter/scripts/shBrushJavaFX.js',
'Perl pl perl #{host}/syntaxhighlighter/scripts/shBrushPerl.js',
'Php php #{host}/syntaxhighlighter/scripts/shBrushPhp.js',
'Plain plain #{host}/syntaxhighlighter/scripts/shBrushPlain.js',
'PowerShell powershell #{host}/syntaxhighlighter/scripts/shBrushPowerShell.js',
'Python py python #{host}/syntaxhighlighter/scripts/shBrushPython.js',
'Ruby rb ruby #{host}/syntaxhighlighter/scripts/shBrushRuby.js',
'Sass sass #{host}/syntaxhighlighter/scripts/shBrushSass.js',
'Scala scala #{host}/syntaxhighlighter/scripts/shBrushScala.js',
'Sql sql #{host}/syntaxhighlighter/scripts/shBrushSql.js',
'Vb vb #{host}/syntaxhighlighter/scripts/shBrushVb.js',
'Xml xml html #{host}/syntaxhighlighter/scripts/shBrushXml.js',
'Haskell haskell hs #{host}/syntaxhighlighter/scripts/shBrushHaskell.js'
);
SyntaxHighlighter.all();
</script>
FOOTER
