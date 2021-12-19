class RemoveThemeToUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :theme, :string
  end
end
