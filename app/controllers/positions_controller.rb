class PositionsController < ApplicationController
  before_action :set_position, only: [:show, :edit, :update, :destroy]
  before_action :get_user_or_redirect
  before_action :only_admin, only: [:index]
  before_action only: [:edit, :update] do
    match_user(@position)
  end
  before_action only:[:new, :create] do
    set_discussion
    match_user(@discussion)
    #editable?(@discussion) #Only the owner of the discussion can create positions
  end
  before_action only: [:destroy] do
    set_discussion
    custom_conditions(match_user(@discussion,no_redirect:true)||match_user(@position,no_redirect:true))
  end
  
  
  
  # GET /positions
  # GET /positions.json
  def index
    @positions = Position.all
  end

  # GET /positions/1
  # GET /positions/1.json
  def show
  end

  # GET /positions/new
  def new
    @position = Position.new(email:params[:email],discussion_id:params[:discussion_id])
  end

  # GET /positions/1/edit
  def edit
  end

  # POST /positions
  # POST /positions.json
  def create
    @position = @discussion.positions.new(position_params)

    respond_to do |format|
      if @position.save
  
        format.html { redirect_to @position.discussion, notice: 'Position was successfully created.' }
        format.json { render :show, status: :created, location: @position.discussion }
      else
        format.html { render :new }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /positions/1
  # PATCH/PUT /positions/1.json
  def update
    respond_to do |format|
      if @position.update(position_params)
        format.html { redirect_to @position, notice: 'Position was successfully updated.' }
        format.json { render :show, status: :ok, location: @position }
      else
        format.html { render :edit }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /positions/1
  # DELETE /positions/1.json
  def destroy
    @position.destroy
    respond_to do |format|
      format.html { redirect_to discussion_path(@discussion), notice: 'Position was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_discussion
      @discussion = Discussion.find_by(params[:discussion_id])
      @discussion||=@position.discussion
    end
    def set_position
      @position = Position.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def position_params
      params.require(:position).permit(:discussion_id, :email, :name, :body, :score)
    end
end
