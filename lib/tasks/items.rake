namespace :items do
  # $ bin/rails items:init_create_item_100000_from_1000
  desc '100000個のitemを1000個ずつランダム生成する'
  task init_create_item_100000_from_1000: :environment do
    100.times do |_i|
      items = []
      random_str = ['Fire', 'Ice', 'Thunder', 'Earth']
      1_000.times do |_j|
        name = "#{random_str[rand(0..random_str.length - 1)]}:#{SecureRandom.hex(6)}"
        item_type = Item::ENUM_ITEM_TYPE.keys.sample
        length = rand(5..100)
        description = SecureRandom.hex(length)
        item = Item.new(
          item_type: item_type,
          name: name,
          description: description
        )
        items << item
      end
      Item.import items, recursive: true
    end
    puts 'データ生成が完了しました。'
  end
end
