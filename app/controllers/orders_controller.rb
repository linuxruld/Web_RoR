class OrdersController < ApplicationController
  
  before_filter :signed_in_user, only: [:index, :update,:show,:create,:new,:finish_order]
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.paginate :page=>params[:page]
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @orders}
    end
  end
  
  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end
  
  # GET /orders/new
  # GET /orders/new.json
  def new
    @cart = current_cart
    if @cart.line_items.empty?
      redirect_to store_url, :notice => "Your cart is empty"
      return
    end
    @order = Order.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @order}
    end
  end
  
  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end
  
  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(params[:order])
    @order.add_line_items_from_cart(current_cart)
    respond_to do |format|
      if @order.save               
        format.html { redirect_to(@order, :notice =>'Thank you for your order.') }
        format.xml { render :xml => @order, :status => :created,:location => @order }
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @order.errors,:status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])
    
    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    
    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end
  
  def finish_order
   @order = Order.find(params[:id])
  end
  
  private
  
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end
  
end
