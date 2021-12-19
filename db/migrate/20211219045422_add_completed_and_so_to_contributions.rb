class AddCompletedAndSoToContributions < ActiveRecord::Migration[6.1]
  def change
    add_column :contributions, :completed, :boolean
    add_column :contributions, :due_date, :datetime
    add_column :contributions, :star, :boolean
  end
end
