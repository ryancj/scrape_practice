class AddTotalreviewsToProduct < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :total_reviews, :string
  end
end
