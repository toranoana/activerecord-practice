# activerecord-practice

This is how to use ActiveRecord and the environment to practice a method. A library and the kind aren't done.

## Versions（利用バージョン）

* Ruby 2.6.5

* Rails 6.0.2

### DB

* MySQL 8.0

### Libraly（利用ライブラリ）

* activerecord-import

https://github.com/zdennis/activerecord-import/releases/tag/v1.0.4

* faker

https://github.com/faker-ruby/faker/releases/tag/v2.10.0

* paranoia

https://github.com/rubysherpas/paranoia/releases/tag/v2.3.1



# Installation（はじめに）

Please git clone.

```sh
$ git clone https://github.com/toranoana/activerecord-practice.git
```

Lets's bundle install!

```sh
$ cd activerecord-practice
$ bundle install --path vendor/bundler
```

# Introduction Procedure（導入手順）

```sh
bin/rails db:create
bin/rails db:migrate
bin/rails people:init_create_people_100000_from_1000
bin/rails items:init_create_item_100000_from_1000
bin/rails item_associate_person:all_associate
```

Now you can practice with ActiveRecord!

If your development environment is Mac, change the following description.

`config/database.yml`

```diff
  port: 3306
  # MacOS環境で動かない場合は以下をコメントアウト
-  socket: /var/run/mysqld/mysqld.sock
+  #socket: /var/run/mysqld/mysqld.sock

```

## Copyright

Copyright (c) 2020 JUNE-JUNE At Toranoana-Lab.
