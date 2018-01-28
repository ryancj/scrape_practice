class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    scrape(@product.asin)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def scrape(asin)
    agent = Mechanize.new
    agent.history_added = Proc.new { sleep 0.5 } #Rate limiting
    page = agent.get("https://www.amazon.com/dp/#{asin}")

    product_name = page.at('span#productTitle').text.strip
    avg_rating = page.at("i[data-hook='average-star-rating']").text
    reviews = page.search("div[data-hook='review']") #Find top reviews on page

    product = reviews.map do |review|
      review_data = review.search('.a-row')

      reviewer = review_data.search('span.a-profile-name').text
      rating = review_data.search("i[data-hook='review-star-rating']").text
      review_header = review_data.search("a[data-hook='review-title']").text
      review_body = review_data.search("div[data-hook='review-collapsed']").text

      @review = Review.new(review_params)
      @review.reviewer = reviewer
      @review.rating = rating
      @review.review_header = review_header
      @review.review_body = review_body
      @review.product = @product
      @review.save
    end

    product.unshift({avg_rating: avg_rating})
    product.unshift({product_name: product_name})

    @product.product_name = product_name
    @product.avg_rating  = avg_rating
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:product_name, :avg_rating, :asin)
    end

    def review_params
      params.permit(:review_header, :reviewer, :rating, :review_body)
    end
end
