require 'benchmark'
require 'objspace'

namespace :people do
  # $ bin/rails people:init_create_people_1000000_from_1000
  desc '1000000人のpeopleを1000人ずつランダム生成する'
  task init_create_people_1000000_from_1000: :environment do
    1_000.times do |_i|
      people = []
      1_000.times do |_j|
        people << create_person_model
      end
      Person.import people, recursive: true
    end
  end

  # $ bin/rails people:init_create_people_100000
  # メモリ使用量：220MB〜240MB
  # 100,000人を一括でインサートした処理時間: 20〜25秒
  # 100,000人を一括でインサートした合計時間: 45〜50秒
  # メモリの負担が大きい。時間も結構かかる。
  desc '100,000人のpeopleをランダム生成する'
  task init_create_people_100000: :environment do
    result2 = Benchmark.realtime do
      people = []
      100_000.times do |_i|
        people << create_person_model
      end
      puts_memory_size
      result = Benchmark.realtime do
        Person.import people, recursive: true
      end
      puts "100,000人を一括でインサートした処理時間: #{result.round(2)}秒"
    end
    puts "100,000人を一括でインサートした合計時間: #{result2.round(2)}秒"
  end

  # $ bin/rails people:init_create_people_100000_from_100
  # ...（ループ中略）
  # メモリ使用量：35〜45MB
  # 100人ずつ一括でインサートした処理時間: 0.02〜0.03秒
  # 100,000人を100人ずつ一括でインサートした処理時間: 60〜65秒
  # インサートクエリの実行時間が削減できており、メモリ負荷も軽減されている
  desc '100000人のpeopleを100人ずつランダム生成する'
  task init_create_people_100000_from_100: :environment do
    result2 = Benchmark.realtime do
      1_000.times do |_i|
        people = []
        100.times do |_j|
          people << create_person_model
        end
        result = Benchmark.realtime do
          Person.import people, recursive: true
        end
        puts_memory_size
        puts "100人ずつ一括でインサートした処理時間: #{result.round(2)}秒"
      end
    end
    puts "100,000人を100人ずつ一括でインサートした処理時間: #{result2.round(2)}秒"
  end

  # $ bin/rails people:init_create_people_100000_from_1000
  # ...（ループ中略）
  # メモリ使用量：35〜45MB
  # 1000人ずつ一括でインサートした処理時間: 0.15〜0.2秒
  # 100,000人を1000人ずつ一括でインサートした処理時間: 35〜40秒
  # インサートクエリの実行時間が削減できており、メモリ負荷も軽減されている
  desc '100000人のpeopleを1000人ずつランダム生成する'
  task init_create_people_100000_from_1000: :environment do
    result2 = Benchmark.realtime do
      100.times do |_i|
        people = []
        1_000.times do |_j|
          people << create_person_model
        end
        puts_memory_size
        result = Benchmark.realtime do
          Person.import people, recursive: true
        end
        puts "1000人ずつ一括でインサートした処理時間: #{result.round(2)}秒"
      end
    end
    puts "100,000人を1000人ずつ一括でインサートした処理時間: #{result2.round(2)}秒"
  end

  # $ bin/rails people:init_create_people_100000_from_10000
  # ...（ループ中略）
  # メモリ使用量：60〜100MB
  # 10,000人ずつ一括でインサートした処理時間: 1.5〜1.9秒
  # 100,000人を10,000人ずつ一括でインサートした処理時間: 30〜35秒
  # インサートが1秒超えており少しパフォーマンス悪くなる
  desc '100,000人のpeopleを10,000人ずつランダム生成する'
  task init_create_people_100000_from_10000: :environment do
    result2 = Benchmark.realtime do
      10.times do |_i|
        people = []
        10_000.times do |_j|
          people << create_person_model
        end
        puts_memory_size
        result = Benchmark.realtime do
          Person.import people, recursive: true
        end
        puts "10,000人ずつ一括でインサートした処理時間: #{result.round(2)}秒"
      end
    end
    puts "100,000人を10,000人ずつ一括でインサートした処理時間: #{result2.round(2)}秒"
  end

    # $ bin/rails people:update_people_name_for_1000
  # 処理時間：0.11秒程
  desc '1000人ずつ一括でアップデート'
  task update_people_name_for_1000: :environment do
    result = Benchmark.realtime do
      Person.limit(1000).update_all("birthday = DATE_ADD(birthday, INTERVAL - 1 DAY)")
    end
    puts "1,000人ずつ一括でアップデートした処理時間: #{result.round(3)}秒"
  end

  # $ bin/rails people:update_people_name_for_10000
  # 処理時間：0.13秒程
  desc '1000人ずつ一括でアップデート'
  task update_people_name_for_10000: :environment do
    result = Benchmark.realtime do
      Person.limit(10000).update_all("birthday = DATE_ADD(birthday, INTERVAL - 1 DAY)")
    end
    puts "10,000人ずつ一括でアップデートした処理時間: #{result.round(3)}秒"
  end

  # $ bin/rails people:update_people_name_for_100000
  # 処理時間：0.3秒程
  # updateの件数で大きな差は見られない。SELECTと同じ条件の絞り込みで差が発生すると思われる。
  desc '100,000人ずつ一括でアップデート'
  task update_people_name_for_100000: :environment do
    result = Benchmark.realtime do
      Person.limit(100000).update_all("birthday = DATE_ADD(birthday, INTERVAL - 1 DAY)")
    end
    puts "100,000人ずつ一括でアップデートした処理時間: #{result.round(3)}秒"
  end

  # $ bin/rails people:update_people_name_where_birthday_for_10000
  # 処理時間：0.14秒程（データ100万件ほど）
  desc '100,00人ずつ一括でアップデート'
  task update_people_name_where_birthday_for_10000: :environment do
    result = Benchmark.realtime do
      Person.where(birthday: Time.zone.local(1970)..Time.zone.local(1990))
        .limit(10000)
        .update_all("birthday = DATE_ADD(birthday, INTERVAL + 1 DAY)")
    end
    puts "100,000人ずつ一括でアップデートした処理時間: #{result.round(3)}秒"
  end

  # $ bin/rails people:update_people_name_where_id_and_birthday_for_10000
  # 処理時間：0.15秒程（データ100万件ほど）
  # SELECTでは明かな差があるが、IDを事前に絞り込むだけでは明かな違いは見られない。
  desc '100,00人ずつ一括でアップデート'
  task update_people_name_where_id_and_birthday_for_10000: :environment do
    result = Benchmark.realtime do
      Person.where(id: 1..100000)
        .where(birthday: Time.zone.local(1970)..Time.zone.local(1990))
        .limit(10000)
        .update_all("birthday = DATE_ADD(birthday, INTERVAL + 1 DAY)")
    end
    puts "100,000人ずつ一括でアップデートした処理時間: #{result.round(3)}秒"
  end

  # $ bin/rails people:check_index_datetime
  desc '瞬間的にインデックスをはる＆日付検索'
  # 処理時間：2.2秒程（データ100万件ほど →200万件だと2倍）
  # セレクト処理時間：0.1～0.2秒程（データ100万件ほど →最終的に取得するデータ量に比例）
  task check_index_datetime: :environment do
    result = Benchmark.realtime do
      ActiveRecord::Base.connection.execute("ALTER TABLE `people` ADD INDEX `birthday` (`birthday`)")
    end
    puts "インデックスを貼るスピード: #{result.round(3)}秒"
    result = Benchmark.realtime do
      count = Person.where(birthday: Time.zone.local(1970)..Time.zone.local(1990)).count
      p "#{count}件"
    end
    puts "インデックス状態での検索: #{result.round(3)}秒"
    ActiveRecord::Base.connection.execute("ALTER TABLE `people` DROP INDEX `birthday`")
  end

  # $ bin/rails people:check_noindex_datetime
  desc 'インデックスをはらずに日付検索'
  # 処理時間：3.5秒程（データ100万件ほど）
  # 処理時間：7.3秒程（データ200万件ほど）
  # テーブル全体のレコード量によって処理時間は比例し、最終的に取得するデータ量に左右されない
  task check_noindex_datetime: :environment do
    result = Benchmark.realtime do
      count = Person.where(birthday: Time.zone.local(1970)..Time.zone.local(1980)).count
      p "#{count}件"
    end
    puts "ノーインデックス状態での検索: #{result.round(3)}秒"
  end

  private

  def create_person_model
    from = Time.zone.local(1960, 1, 1)
    to   = Time.zone.local(2020, 1, 1)
    Person.new(
      sex: rand(1..2),
      birthday: rand(from..to),
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name
    )
  end

  def puts_memory_size
    puts "メモリ使用量：#{(ObjectSpace.memsize_of_all * 0.001 * 0.001).round(2)} MB"
  end
end
