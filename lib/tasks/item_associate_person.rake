namespace :item_associate_person do
  # $ bin/rails item_associate_person:all_associate
  desc '全てのitemをpersonに関連づける'
  task all_associate: :environment do
    # 道具所持テーブルを参照
    person_item_storages = PersonItemStorage.select(:item_id)
    # peopleの人数
    people_count = Person.count
    # 時間計測用の変数
    index = 1
    # 1000件ずつ実施。既に所持テーブルが作られているものは除外する。
    Item.where.not(id: person_item_storages).find_in_batches(batch_size: 1000) do |items|
      puts "#{index}:連携用のItemデータを1000件取得"
      # 一括インサート用の変数
      insert_storages = []
      # ある程度のランダム性を持たせるため、一時的に2000件のユーザのIDを取得しておく
      # order('RAND()')ではなくoffsetを使うのは、高速化のため
      person_ids = Person.limit(2000).offset(rand(0..(people_count - 2000))).pluck(:id)
      puts "#{index}:連携用のPersonデータをランダムに2000件取得"

      items.each do |item|
        insert_storages << PersonItemStorage.new(
          person_id: person_ids[rand(person_ids.length)],
          item_id: item.id
        )
      end
      puts "#{index}:一括インサート用のデータを1000件分生成"

      PersonItemStorage.import insert_storages, recursive: true
      puts "#{index}:1000件の連携データがインサートされました。"
      index += 1
    end
    puts '全ての道具が所持されるよう連携が完了しました。'
  end
end
