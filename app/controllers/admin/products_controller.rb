class Admin::ProductsController < Admin::ApplicationController
  before_action :find_product, only: [:show, :update, :trash, :restore]

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
      redirect_to admin_product_path(@product)
    else
      render :new
    end
  end

  def show
  end

  def update
    if @product.update_attributes product_params
      flash[:success] = I18n.t('admin.products.flashes.successfully_updated')
      redirect_to admin_product_path(@product)
    else
      redirect_to :back
    end
  end

  def trash
    puts @product.id
    Product.with_trashed.find(11).trash
    flash[:success] = I18n.t('admin.products.flashes.successfully_trashed')
    redirect_to admin_product_path(@product)
  end

  def restore
    @product.restore
    flash[:success] = I18n.t('admin.products.flashes.successfully_restored')
    redirect_to admin_product_path(@product)
  end

  private

  def product_params
    params.require(:product).permit(:name, :price)
  end

  def find_product
    @product = Product.with_trashed.find params[:id]
  end
end
