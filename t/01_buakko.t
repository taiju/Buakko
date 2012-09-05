use strict;
use Test::More;
use Buakko;

my $buakko = Buakko->new;
isa_ok($buakko, 'Buakko');

{
    my $sexp = <<'SEXP';
(element)
SEXP
  
   is('<element />', $buakko->parse($sexp), 'element only');
}

{
   my $sexp = <<'SEXP'; 
(element "value")
SEXP

   is('<element>value</element>', $buakko->parse($sexp), 'element and value');
}

{
   my $sexp = <<'SEXP'; 
(script "var name = \"taiju\"; alert(name);")
SEXP

   is('<script>var name = "taiju"; alert(name);</script>', $buakko->parse($sexp), 'double quotes in value');
}


{
   my $sexp = <<'SEXP'; 
(element "value1" " " "value2")
SEXP

   is('<element>value1 value2</element>', $buakko->parse($sexp), 'element and some values');
}

{
   my $sexp = <<'SEXP'; 
(element1
  "value1"
  (element2 "value2")
  (element3
    "value3"
    (element3_5 "value3_5"))
  (element4 "value4"))
SEXP

   is('<element1>value1<element2>value2</element2><element3>value3<element3_5>value3_5</element3_5></element3><element4>value4</element4></element1>', $buakko->parse($sexp), 'nested element and value');
}

{
    my $sexp = <<'SEXP';
(element (@attr "hoge"))
SEXP

   is('<element attr="hoge" />', $buakko->parse($sexp), 'element and attribute');
}

{
    my $sexp = <<'SEXP';
(element (@attr1 "hoge" @attr2 "fuga"))
SEXP

   is('<element attr1="hoge" attr2="fuga" />', $buakko->parse($sexp), 'element and some attributes');
}

{
    my $sexp = <<'SEXP';
(element (@attr1 "hoge" @attr2 "fuga") "value")
SEXP

   is('<element attr1="hoge" attr2="fuga">value</element>', $buakko->parse($sexp), 'element and some attributes and value');
}

{
    my $sexp = <<'SEXP';
(div (@id "header") # ヘッダー開始
  (h1 "title")
  (p "Hello!!") # ヘッダー終了
  )
SEXP

   is('<div id="header"><!--ヘッダー開始--><h1>title</h1><p>Hello!!</p><!--ヘッダー終了--></div>', $buakko->parse($sexp), 'comments');
}

{
    my $sexp = <<'SEXP';
(xml (@version "1.0" @charset "utf-8")
  (root
    (node1 "node1")
    (node2 "node2")))
SEXP

   is('<?xml version="1.0" charset="utf-8"?><root><node1>node1</node1><node2>node2</node2></root>', $buakko->parse($sexp), 'xml declaration');
}

{
    my $sexp = <<'SEXP';
(html (@lang "ja")
  (head
    (meta (@charset "utf-8"))
    (title "title"))
  (body "hello"))
SEXP

   is('<!doctype html><html lang="ja"><head><meta charset="utf-8" /><title>title</title></head><body>hello</body></html>', $buakko->parse($sexp), 'html with doctype');
}

{
    my $sexp = <<'SEXP';
(xml (@version "1.0" @encoding "utf-8")
  (html (@lang "ja")
    (head # ヘッダ
      (meta (@charset "utf-8"))
      (title "EXAMPLE"))
    (body (@class "example home") # ボディ
      (h1 "example!")
      (p 
        (a (@href "http://example.com/" @target "_blank") "example web site.")))))
SEXP

   is('<?xml version="1.0" encoding="utf-8"?><!doctype html><html lang="ja"><head><!--ヘッダ--><meta charset="utf-8" /><title>EXAMPLE</title></head><body class="example home"><!--ボディ--><h1>example!</h1><p><a href="http://example.com/" target="_blank">example web site.</a></p></body></html>', $buakko->parse($sexp), 'full');
}

done_testing;
