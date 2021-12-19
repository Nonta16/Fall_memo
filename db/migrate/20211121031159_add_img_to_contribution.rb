class AddImgToContribution < ActiveRecord::Migration[6.1]
  def change
    add_column :contribution, :img, :string
  end
end
