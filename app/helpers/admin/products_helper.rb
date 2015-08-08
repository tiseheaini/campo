module Admin::ProductsHelper
  def product_link(product)
    return <<-END
      <a href="#{ new_order_path(product_id: product.id) }" id="product-link" target="_blank" style="display: block;">#{product.name}</a>
    END
  end
end
