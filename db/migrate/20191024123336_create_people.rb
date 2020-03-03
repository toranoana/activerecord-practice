class CreatePeople < ActiveRecord::Migration[6.0]
  def change
    create_table :people do |t|
      t.integer :sex, null: false, default: 1, comment: '性別'
      t.datetime :birthday, null: true, comment: '生年月日'
      t.timestamps
    end
  end
end
