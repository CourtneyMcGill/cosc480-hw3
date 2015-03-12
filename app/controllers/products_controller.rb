class ProductsController < ApplicationController
  def index
        if params.has_key?(:filter) && params.has_key?(:sort)
            @products = Product.filter_by(params[:filter])
            session[:filter] = params[:filter]
            @products = @products.sorted_by(params[:sort])
            session[:sort] = params[:sort]
        elsif params.has_key?(:filter)
            flash.keep
            redirect_to products_path :sort => session[:sort], :filter => params[:filter]
        elsif params.has_key?(:sort)
            flash.keep
            redirect_to products_path :sort => params[:sort], :filter => session[:filter]            
        else
            if session[:sort].nil?
                def_sort = "name"
            else
                def_sort = session[:sort]
            end
            if session[:filter].nil?
                def_filter = { :min_age => String.new, :max_price => String.new}
            else
                def_filter = session[:filter]
            end
            flash.keep
            redirect_to products_path :sort => def_sort, :filter => def_filter
        end
  end

  def show
        @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(create_update_params)
    if @product.save
        flash[:notice] = "New product #{@product.name} created successfully"
        redirect_to products_path
    else
        flash[:warning] = "Your new product was not uploaded"
        redirect_to new_product_path
    end
  end

  def edit
    @product = Product.find(params[:id])
  end      

  def update
    @product = Product.find(params[:id])
    @product.update(create_update_params)
    if @product.save
        flash[:notice] = "#{@product.name} successfully updated"
        redirect_to product_path(@product)
    else
        flash[:warning] = "The product was NOT updated!"
        redirect_to edit_product_path(@product)
    end
  end

private
  def create_update_params
        params.require(:product).permit(:name, :description, :price, :minimum_age_appropriate, :maximum_age_appropriate, :image)
  end
end
