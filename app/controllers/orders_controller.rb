class OrdersController < ApplicationController
  def new
    @product = Product.find params[:product_id]

    if params[:product_id].present? && request.referer.present?
      resource, id = URI(request.referer).path.split('/')[1, 2]
      @topic = resource.singularize.classify.constantize.find(id)
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
