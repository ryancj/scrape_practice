class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.references :product, foreign_key: true
      t.string :reviewer
      t.string :rating
      t.string :review_header
      t.text :review_body

      t.timestamps
    end
  end
end
