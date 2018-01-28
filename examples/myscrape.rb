require 'mechanize'
require 'date'
require 'json'
require 'pry-byebug'

agent = Mechanize.new
agent.history_added = Proc.new { sleep 0.5 } #Rate limiting
page = agent.get('https://www.amazon.com/dp/B002QYW8LW')

product_name = page.at('span#productTitle').text.strip
avg_rating = page.at("i[data-hook='average-star-rating']").text
total_reviews = page.search("span[data-hook='total-review-count']").text

product = {product_name: product_name, avg_rating: avg_rating, total_reviews: total_reviews}

reviews = page.search("div[data-hook='review']")

all_reviews = reviews.map do |review|
  review_data = review.search('.a-row')

  reviewer = review_data.search('span.a-profile-name').text
  avatar = review.search('.a-profile-avatar img')[1].attribute('src').value
  rating = review_data.search("i[data-hook='review-star-rating']")[0..2]
  review_header = review_data.search("a[data-hook='review-title']").text
  date = review.search("span[data-hook='review-date']").text
  review_body = review_data.search("div[data-hook='review-collapsed']").text
  type_and_verified = review.search(".a-row.review-format-strip").text
  {
    reviewer: reviewer,
    avatar: avatar,
    rating: rating,
    review_header: review_header,
    date: date,
    review_body: review_body,
    type_and_verified: type_and_verified
  }
end

product["reviews"] = all_reviews

puts JSON.pretty_generate(product)
