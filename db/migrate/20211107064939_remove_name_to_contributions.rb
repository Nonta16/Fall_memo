class RemoveNameToContributions < ActiveRecord::Migration[6.1]
  def change
    remove_column :contributions, :name, :string
  end
end
