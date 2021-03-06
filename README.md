[ja](./README.ja.md)

# NewerReposClone

Clone the last pushed repository.

# Requirement

* <time datetime="2022-01-18T14:06:41+0900">2022-01-18</time>
* [Raspbierry Pi](https://ja.wikipedia.org/wiki/Raspberry_Pi) 4 Model B Rev 1.2
* [Raspberry Pi OS](https://ja.wikipedia.org/wiki/Raspbian) buster 10.0 2020-08-20 <small>[setup](http://ytyaru.hatenablog.com/entry/2020/10/06/111111)</small>
* bash 5.0.3(1)-release

```sh
$ uname -a
Linux raspberrypi 5.10.63-v7l+ #1496 SMP Wed Dec 1 15:58:56 GMT 2021 armv7l GNU/Linux
```

# Installation

```sh
git clone https://github.com/ytyaru/Shell.NewerReposClone.20220118140658
```

# Usage

```sh
cd Shell.NewerReposClone.20220118140658/src
./run.sh
```

コマンド|意味
--------|----
`./run.sh`|Clone the last repository pushed by the `ytyaru` user.
`./run.sh 3`|Clone the last three `ytyaru` user pushed repositories in chronological order.
`./run.sh $USER`|Clone the last repository pushed by the `$USER` user.
`./run.sh $USER 3`|Clone the last three `$USER` user pushed repositories in chronological order.

* show [README.ja.md](./README.ja.md)

# Author

ytyaru

* [![github](http://www.google.com/s2/favicons?domain=github.com)](https://github.com/ytyaru "github")
* [![hatena](http://www.google.com/s2/favicons?domain=www.hatena.ne.jp)](http://ytyaru.hatenablog.com/ytyaru "hatena")
* [![twitter](http://www.google.com/s2/favicons?domain=twitter.com)](https://twitter.com/ytyaru1)
* [![mastodon](http://www.google.com/s2/favicons?domain=mstdn.jp)](https://mstdn.jp/web/accounts/233143 "mastdon")

# License

This software is CC0 licensed.

[![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png "CC0")](http://creativecommons.org/publicdomain/zero/1.0/deed.en)

