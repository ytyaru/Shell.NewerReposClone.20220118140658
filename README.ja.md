[en](./README.md)

# NewerReposClone

　最後にpushしたリポジトリをクローンする。

# 開発環境

* <time datetime="2022-01-18T14:06:41+0900">2022-01-18</time>
* [Raspbierry Pi](https://ja.wikipedia.org/wiki/Raspberry_Pi) 4 Model B Rev 1.2
* [Raspberry Pi OS](https://ja.wikipedia.org/wiki/Raspbian) buster 10.0 2020-08-20 <small>[setup](http://ytyaru.hatenablog.com/entry/2020/10/06/111111)</small>
* bash 5.0.3(1)-release

```sh
$ uname -a
Linux raspberrypi 5.10.63-v7l+ #1496 SMP Wed Dec 1 15:58:56 GMT 2021 armv7l GNU/Linux
```

# インストール

```sh
git clone https://github.com/ytyaru/Shell.NewerReposClone.20220118140658
```

# 使い方

```sh
cd Shell.NewerReposClone.20220118140658/src
./run.sh
```

コマンド|意味
--------|----
`./run.sh`|`ytyaru`ユーザが最後にpushしたリポジトリを1つクローンする
`./run.sh 3`|`ytyaru`ユーザが最後にpushしたリポジトリを日時順に3つクローンする
`./run.sh $USER`|ユーザ名`$USER`が最後にpushしたリポジトリを1つクローンする
`./run.sh $USER 3`|ユーザ名`$USER`が最後にpushしたリポジトリを日時順に3つクローンする

　デフォルトのユーザ名を変えたければソースコードの変数`INIT_USER`を変更すればよい。

## シンボリックリンク＆環境変数PATH

　どこからでも簡単に実行できるようになる。

1. 実行ファイル`run.sh`のシンボリックリンク`clone`を作る
1. 1を環境変数`PATH`に通してやる
1. 端末を起動し`clone`コマンドを実行する

```sh
ln -s ./run.sh /path/clone
```

~/.bashrc
```sh
export /path
```

　あとは端末を起動して`clone`コマンドを実行するだけ。

```sh
clone
```

　ここでは`/path`パスに環境変数`PATH`を通して、そこに`clone`というシンボリックリンク

## ヘルプ

　`./run.sh -h`でヘルプを表示する。

```sh
最後にpushしたリポジトリをクローンする。	0.0.1
clone [-hvd] [USER] [NUM]
OptionArguments:
  USER  GitHubユーザ名。初期値:ytyaru
  NUM   取得数。初期値:1
TSV:
  ~/root/work/record/pc/account/github/tokens.tsv
Examples:
  clone
  clone 3
  clone ytyaru
  clone ytyaru 3
OptionSwitch:
  -d    デバッグ出力
SubCommand
  -h    ヘルプ
  -v    バージョン
```

## TOKEN_TSV

　リポジトリの取得にはGitHub APIを使用している。このときOAuth2認証するためにTOKENが必要となる。

### 認証

　リポジトリ取得APIは認証なしでも実行できるが、リクエスト上限を回避する狙いで認証ありで実行する。

　OAuth2でなく基本認証でも実行できるが、今回はOAuth2認証のみ対応にした。基本認証は、毎回パスワードを手入力するか、ハードコーディングすることになってしまいセキュリティ的に問題なのと、自動化できないため。

### トークン作成

1. GitHubにログインする
1. `Setting`→` Developer settings`→`Personal accesso tokens`→`Generate new token`で作成する
1. `repo`スコープを持たせる
1. 作成したトークンをコピーしておく

　「期限なし」で作成すればずっと使い回せて楽。デフォルトでは30日期限つきで作成させようとするので注意。

　スコープは`repo`があれば十分。`private`リポジトリを対象外にしていいなら`public_repo`だけでいい。スコープはできるだけ絞ったほうが万一漏洩したときの被害を最小限に抑えられる。利便性とのトレードオフなので好きに決めたらいい。

### TSV作成

　保存すべきファイルパスはヘルプやコードに書いてある。

　以下を参考にする。

* [tokens.tsv](src/tokens.tsv)

　TSVはユーザ名、トークン、ノート（任意文字列）の3つ。このうち最低でもユーザ名とトークンが必要。

```tsv
username	token	note(ScopeCsv)
```

　たとえば`user1`ユーザがトークン`abcdefg...`を作成した場合、以下のように書く。
　`username`と`note`で絞り込む。`username`

```tsv
user1	user1token_all	
```

　同じユーザで複数のトークンを使い分けたいときはノートで一意に識別できるようにすること。ノートには所持しているスコープを指定してやるとよい。

```tsv
user1	user1token_all	repo
user1	user1token_all	public_repo
user1	user1token_all	user
```

　デフォルトでは`repo`で絞り込もうとする。ノートの値をrepo以外の値で絞り込むようには実装していない。ユーザ名だけで複数ヒットし、ノートで絞り込んだら一件もヒットしないときは、ユーザ名だけでヒットしたときの先頭行を返す。なので優先度の高いトークンを各ユーザの先頭行に配置するとよい。

# 著者

　ytyaru

* [![github](http://www.google.com/s2/favicons?domain=github.com)](https://github.com/ytyaru "github")
* [![hatena](http://www.google.com/s2/favicons?domain=www.hatena.ne.jp)](http://ytyaru.hatenablog.com/ytyaru "hatena")
* [![twitter](http://www.google.com/s2/favicons?domain=twitter.com)](https://twitter.com/ytyaru1)
* [![mastodon](http://www.google.com/s2/favicons?domain=mstdn.jp)](https://mstdn.jp/web/accounts/233143 "mastdon")

# ライセンス

　このソフトウェアはCC0ライセンスである。

[![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png "CC0")](http://creativecommons.org/publicdomain/zero/1.0/deed.ja)

