class CreatePersonItemStorages < ActiveRecord::Migration[6.0]
  def change
    create_table :person_item_storages do |t|
      t.references :person, foreign_key: true
      t.references :item, foreign_key: true
      t.datetime :deleted_at, null: true
      t.timestamps
    end
  end
end
