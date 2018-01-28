class AddColumnsToReview < ActiveRecord::Migration[5.1]
  def change
    add_column :reviews, :avatar, :string
    add_column :reviews, :date, :date
    add_column :reviews, :type_and_verified, :string
  end
end
