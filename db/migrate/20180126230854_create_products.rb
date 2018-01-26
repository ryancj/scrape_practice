class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :product_name
      t.float :avg_rating
      t.string :asin

      t.timestamps
    end
  end
end
