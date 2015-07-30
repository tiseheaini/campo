class Admin::ProductsController < Admin::ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.order(created_at: :desc)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params

    if @product.save
      flash[:success] = I18n.t('admin.products.flashes.successfully_created')
      redirect_to admin_products_path
    else
      render :new
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :price)
  end

  def find_product
    @product = Product.find params[:id]
  end
end
