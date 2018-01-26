json.extract! product, :id, :product_name, :avg_rating, :asin, :created_at, :updated_at
json.url product_url(product, format: :json)
