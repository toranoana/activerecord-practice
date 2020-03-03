class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.integer :type, null: false, default: 0, comment: '種別（武器、薬、道具）'
      t.string :name, null: false, comment: 'アイテム名'
      t.string :description, null: false, comment: 'アイテム説明'
      t.timestamps
    end
  end
end
