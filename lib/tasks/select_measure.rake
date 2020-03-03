require 'benchmark'
require 'objspace'

namespace :select_measure do
  # $ bin/rails select_measure:count_all_person
  # 一度配列やモデルとして取得した後にlengthで数えるよりも、
  # SQLの中でcountしたほうが圧倒的に早い。
  # またcountを*にするかidにするかでの違いはない。
  desc 'peopleテーブルの数を数える'
  task count_all_person: :environment do
    result = Benchmark.realtime do
      ids = Person.all.pluck(:id)
      puts "peopleの数：#{ids.length}"
    end
    puts "Array+length方式: #{result.round(2)}秒"

    result2 = Benchmark.realtime do
      puts "peopleの数：#{Person.all.count}"
    end
    puts "count方式: #{result2.round(2)}秒"
  
    result3 = Benchmark.realtime do
      puts "peopleの数：#{Person.all.count(:id)}"
    end
    puts "id限定count方式: #{result3.round(2)}秒"
  end

  # $ bin/rails select_measure:select_random_person
  # ランダムなIDを取得する処理
  # order+RAND方式は16秒程度かかる。
  # limit+offset方式は5秒前後だが取得したデータが完全ランダムではなく連番。
  desc 'peopleテーブルからランダムにデータを取得する'
  task select_random_person: :environment do
    result = Benchmark.realtime do
      query = Person.order('RAND()').limit(100)
      puts "発行SQL: #{query.to_sql}"
      query.reload
    end
    puts "order+RAND()方式: #{result.round(2)}秒"
  
    result2 = Benchmark.realtime do
      people_count = Person.count
      offset_int = rand(0..(people_count - 100))
      query = Person.limit(100).offset(rand(0..(people_count - 100)))
      puts "発行SQL: #{query.to_sql}"
      query.reload
    end
    puts "limit+offset方式: #{result2.round(2)}秒"
  end

  # $ bin/rails select_measure:count_bob_have_item
  # ボブという名前を持っている人のアイテム数を計測する
  # 1回で実行するクエリであれば時間の差はない
  # 可読性の観点からいうと、やはりItemをベースとしてIN句の形式が最良か
  desc 'ボブが持っているアイテム数を計測する'
  task count_bob_have_item: :environment do
    result = Benchmark.realtime do
      person_ids = Person.where(first_name: 'Bob').pluck(:id)
      storage_ids = PersonItemStorage.where(person_id: person_ids).pluck(:id)
      item_query = Item.where(id: storage_ids)
      puts "発行SQL: #{item_query.to_sql}"

      puts "ボブが持ってる数: #{item_query.count}"
    end
    puts "都度取得方式: #{result.round(2)}秒"

    result = Benchmark.realtime do
      query = Item.where(id: PersonItemStorage.where(person: Person.where(first_name: 'Bob')))
      puts "発行SQL: #{query.to_sql}"
      puts "ボブが持ってる数: #{query.count}"
    end
    puts "ItemベースのIN句方式: #{result.round(2)}秒"

    result = Benchmark.realtime do
      query = Item.joins(person_item_storage: :person).where(people: { first_name: 'Bob' })
      puts "発行SQL: #{query.to_sql}"
      puts "ボブが持ってる数: #{query.count}"
    end
    puts "ItemベースのJOIN方式: #{result.round(2)}秒"

    result = Benchmark.realtime do
      query = Person.joins(person_item_storages: :item).where(people: { first_name: 'Bob' })
      puts "発行SQL: #{query.to_sql}"
      puts "ボブが持ってる数: #{query.count}"
    end
    puts "PersonベースのJOIN方式: #{result.round(2)}秒"

    result = Benchmark.realtime do
      query = Item.eager_load(person_item_storage: :person).where(people: { first_name: 'Bob' })
      puts "発行SQL: #{query.to_sql}"
      puts "ボブが持ってる数: #{query.count}"
    end
    puts "ItemベースのEagerLoad方式: #{result.round(2)}秒"
  end

  desc '最も多くのアイテムを持っている人を見つける'
  task loockup_most_have_item_person: :environment do
    person_hash = {}
    result = Benchmark.realtime do
      # 最も多く持っているユーザを一人だけ取得
      person_hash = PersonItemStorage.group(:person_id).count
    end
    puts "クエリ処理時間: #{result.round(2)}秒"
    person_count = {}
    result2 = Benchmark.realtime do
      person_count = person_hash.sort_by { |_, v| v }.reverse.first
    end
    puts "ハッシュソート処理時間: #{result2.round(2)}秒"
    puts "最も多く持っているユーザ:#{person_count[0]}　件数:#{person_count[1]}"
    puts_memory_size
    puts "ハッシュ取得方式: #{(result + result2).round(2)}秒"

    result = Benchmark.realtime do
      # 最も多く持っているユーザを一人だけ取得
      person_count = PersonItemStorage.group(:person_id).order(count_all: 'DESC').count.first
      puts "最も多く持っているユーザ:#{person_count[0]}　件数:#{person_count[1]}"
    end
    puts_memory_size
    puts "クエリ取得方式: #{result.round(2)}秒"
  end

  private

  def puts_memory_size
    puts "メモリ使用量：#{(ObjectSpace.memsize_of_all * 0.001 * 0.001).round(2)} MB"
  end
end
