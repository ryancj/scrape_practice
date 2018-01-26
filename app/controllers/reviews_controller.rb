class ReviewsController < ApplicationController

  def create
    @product          = Product.find params[:product_id]
    review_params = params.require(:review).permit(:review_header, :reviewer, :rating, :review_body)
    @review       = Review.new(review_params)
    @review.product  = @product
    if @review.save
      redirect_to product_path(@product), notice: "Review created"
    else
      render "/products/show"
    end

  end

end
