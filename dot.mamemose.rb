# -*- coding: utf-8 -*-
DOCUMENT_ROOT = "~/memo"

MARKDOWN_PATTERN = /\.(md|markdown|txt)$/

INDEX_PATTERN = /^README\.(md|markdown|txt)$/

# RECENT_NUM = 0

RECENT_PATTERN = /\.(md|markdown|txt|key|tex|pdf)$/

CUSTOM_HEADER = <<HEADER
<script type="text/javascript" src="/MathJax/MathJax.js?config=TeX-AMS_HTML"></script>
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
<link href="/syntaxhighlighter/styles/shCoreGitHub.css" rel="stylesheet" type="text/css" />
<script src="/syntaxhighlighter/scripts/shCore.js" type="text/javascript"></script>
<script src="/syntaxhighlighter/scripts/shAutoloader.js" type="text/javascript"></script>
<script type="text/javascript">
SyntaxHighlighter.autoloader(
'AS3 as3 /syntaxhighlighter/scripts/shBrushAS3.js',
'AppleScript applescript /syntaxhighlighter/scripts/shBrushAppleScript.js',
'Bash bash /syntaxhighlighter/scripts/shBrushBash.js',
'CSharp csharp /syntaxhighlighter/scripts/shBrushCSharp.js',
'ColdFusion coldfusion /syntaxhighlighter/scripts/shBrushColdFusion.js',
'Cpp cpp /syntaxhighlighter/scripts/shBrushCpp.js',
'Css css /syntaxhighlighter/scripts/shBrushCss.js',
'Delphi delphi /syntaxhighlighter/scripts/shBrushDelphi.js',
'Diff diff /syntaxhighlighter/scripts/shBrushDiff.js',
'Erlang erlang /syntaxhighlighter/scripts/shBrushErlang.js',
'Groovy /syntaxhighlighter/scripts/shBrushGroovy.js',
'JScript jscript javascript js /syntaxhighlighter/scripts/shBrushJScript.js',
'Java java /syntaxhighlighter/scripts/shBrushJava.js',
'JavaFX javafx /syntaxhighlighter/scripts/shBrushJavaFX.js',
'Perl perl /syntaxhighlighter/scripts/shBrushPerl.js',
'Php php /syntaxhighlighter/scripts/shBrushPhp.js',
'Plain plain /syntaxhighlighter/scripts/shBrushPlain.js',
'PowerShell powershell /syntaxhighlighter/scripts/shBrushPowerShell.js',
'Python python /syntaxhighlighter/scripts/shBrushPython.js',
'Ruby ruby /syntaxhighlighter/scripts/shBrushRuby.js',
'Sass sass /syntaxhighlighter/scripts/shBrushSass.js',
'Scala scala /syntaxhighlighter/scripts/shBrushScala.js',
'Sql sql /syntaxhighlighter/scripts/shBrushSql.js',
'Vb vb /syntaxhighlighter/scripts/shBrushVb.js',
'Xml xml html /syntaxhighlighter/scripts/shBrushXml.js',
'Lisp lisp scheme elisp /syntaxhighlighter/scripts/shBrushLisp.js',
'Haskell haskell /syntaxhighlighter/scripts/shBrushHaskell.js',
'Latex latex /syntaxhighlighter/scripts/shBrushLatex.js'
);
SyntaxHighlighter.all();
</script>
FOOTER
