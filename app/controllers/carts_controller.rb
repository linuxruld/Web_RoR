class CartsController < ApplicationController
  
  before_filter :signed_in_user, only: [:index, :edit, :update,:show,:new,:create]
  before_filter :correct_user,   only: [:index, :edit, :update,:show,:new,:create]
  # GET /carts
  # GET /carts.json
  def index
    @carts = Cart.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @carts }
    end
  end
  
  # GET /carts/1
  # GET /carts/1.json
  def show
    begin
      @cart = Cart.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to store_url, :notice => 'Invalid cart'
    else
      respond_to do |format|
        format.html # show.html.erb
        format.xml { render :xml => @cart}
      end
    end
  end
  
  # GET /carts/new
  # GET /carts/new.json
  def new
    @cart = Cart.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cart }
    end
  end
  
  # GET /carts/1/edit
  def edit
    @cart = Cart.find(params[:id])
  end
  
  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(params[:cart])
    
    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render json: @cart, status: :created, location: @cart }
      else
        format.html { render action: "new" }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /carts/1
  # PUT /carts/1.json
  def update
    @cart = Cart.find(params[:id])
    
    respond_to do |format|
      if @cart.update_attributes(params[:cart])
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart = current_cart
    @cart.destroy
    session[:cart_id] = nil
    respond_to do |format|
      format.html { redirect_to(store_url)}
      format.xml { head :ok}
    end
  end
  

  private
  
   def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end


end
