class AddEnabledToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :enabled, :boolean, default: true, null: false
  end
end
