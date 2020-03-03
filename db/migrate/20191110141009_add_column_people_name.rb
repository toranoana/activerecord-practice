class AddColumnPeopleName < ActiveRecord::Migration[6.0]
  def change
    add_column :people, :first_name, :string, after: :sex
    add_column :people, :last_name, :string, after: :first_name
  end
end
