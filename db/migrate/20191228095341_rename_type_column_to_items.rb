class RenameTypeColumnToItems < ActiveRecord::Migration[6.0]
  def change
    rename_column :items, :type, :item_type
  end
end
