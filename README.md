What's ?
===============
chef で使用する Redmine の cookbook です。

Usage
-----
cookbook なので berkshelf で取ってきて使いましょう。

* Berksfile
```ruby
source "https://supermarket.chef.io"

cookbook "redmine", git: "https://github.com/bageljp/cookbook-redmine.git"
```

```
berks vendor
```

Recipes
----------

#### redmine::default
redmine のインストールと設定。

TODO
----------

* rakeコマンドやpassenger周りもレシピにしたい。

