# Buakko
S式 -> (HT|X)MLコンバータ

## What's Buakko
Lispの仏様と言われた竹内郁雄先生は、XMLを[分厚いカッコのあるLispとおっしゃって](http://jibun.atmarkit.co.jp/ljibun01/rensai/genius/01/01.html)いるそうです。

実際に、S式で(HT|X)MLを書くと、自然でシンプルに書けるので、S式を(HT|X)MLに変換する単純なコンバータを作りました。

ネーミングのBuakkoは「分厚いカッコ」をもじりました。

[hiccup](https://github.com/weavejester/hiccup)が非常に便利なのですが、なかなかClojureを使える機会というのは少なく、いつでもhiccupのような仕組みを使いたいというのが作った動機の一つです。

非常に簡単な仕組みで作られているので、うるさくないかわりに、随分緩いです。

## SYNOPSIS
```bash
$ buakko hoge > hoge.html
```

### input file: hoge
```scheme
(html (@lang "ja")
  (head # ヘッダ
    (meta (@charset "utf-8"))
    (title "EXAMPLE"))
  (body (@class "example home") # ボディ
    (h1 "example!")
    (p 
      (a (@href "http://example.com/" @target "_blank") "example web site."))))
```

### output file: hoge.html
```html
<!doctype html><html lang="ja"><head><!--ヘッダ--><meta charset="utf-8" /><title>EXAMPLE</title></head><body class="example home"><!--ボディ--><h1>example!</h1><p><a href="http://example.com/" target="_blank">example web site.</a></p></body></html>
```

## INSTALL
CPANに置いていないので、cpanmでtarballからインストールします。

- 以下からtarballをダウンロードします。
  - [https://github.com/downloads/taiju/Buakko/Buakko-0.01.tar.gz](https://github.com/downloads/taiju/Buakko/Buakko-0.01.tar.gz)
- ダウンロード先のディレクトリに移動し、以下のコマンドを実行します。

```bash
$ cpanm ./Buakko-0.01.tar.gz
```

## SPECIFICATION

### 要素（値なし）
```scheme
(element)
```

```html
<element />
```

カッコの先頭は、常に要素名。

値がない場合は、開始タグの最後にスラッシュを入れて閉じます。

### 要素（値あり）
```scheme
(element "value")
```

```html
<element>value</element>
```

値はダブルクォーテーションで囲む必要があります。

### 要素（値にダブルクォーテーションあり）
```scheme
(script "var name = \"taiju\"; alert(name);")
```

```html
<script>var name = "taiju"; alert(name);</script>
```

### 要素（値複数あり）
```scheme
(element "value1" " " "value2")
```

```html
<element>value1 value2</element>
```

値は複数指定できます。

### 要素のネスト
```scheme
(element1
  "value1"
  (element2 "value2")
  (element3
    "value3"
    (element3_5 "value3_5"))
  (element4 "value4"))
```

```html
<element1>value1<element2>value2</element2><element3>value3<element3_5>value3_5</element3_5></element3><element4>value4</element4></element1>
```

要素の入れ子ができます。

### 属性
```scheme
(element (@attr "hoge"))
```

```html
<element attr="hoge" />
```

属性を指定できます。属性は必ずキーと値が対で必要です。キーには先頭に`@`を付ける必要があります。

### 属性（複数）
```scheme
(element (@attr1 "hoge" @attr2 "fuga"))
```

```html
<element attr1="hoge" attr2="fuga" />
```

属性も複数の値が指定できます。

### コメント
```scheme
(div (@id "header") # ヘッダー開始
  (h1 "title")
  (p "Hello!!") # ヘッダー終了
  )
```

```html
<div id="header"><!--ヘッダー開始--><h1>title</h1><p>Hello!!</p><!--ヘッダー終了--></div>
```

対応しているのは1行コメントのみです。`#`から行末までコメントになります。
全体のカッコの外側に記述することはできませんので、上記のようにカッコの対応箇所を調整する必要がある場合もあります。

### XML宣言
```scheme
(xml (@version "1.0" @charset "utf-8")
  (root
    (node1 "node1")
    (node2 "node2")))
```

```html
<?xml version="1.0" charset="utf-8"?><root><node1>node1</node1><node2>node2</node2></root>
```

### doctype
```scheme
(html (@lang "ja")
  (head
    (meta (@charset "utf-8"))
    (title "title"))
  (body "hello"))
```

```html
<!doctype html><html lang="ja"><head><meta charset="utf-8" /><title>title</title></head><body>hello</body></html>
```

html要素を使うと自動的にdoctypeが付与されます。

### SEEALLSO
```bash
$ perldoc Buakko
```

### LISENCE
Copyright (c) 2012, taiju. All rights reserved.

MIT License.
