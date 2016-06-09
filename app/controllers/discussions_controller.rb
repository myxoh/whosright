class DiscussionsController < ApplicationController
  include VotableController
  before_action :set_discussion, only: [:show, :edit, :update, :destroy, :publish]
  before_action :get_user_or_redirect
  before_action only: [:edit, :destroy, :update] do
    match_user(@discussion)
  end

  # GET /discussions
  # GET /discussions.json
  def index
    @from_user = User.find(params[:user_id])
    @published = @from_user.discussions.published
    if @user.owns? @from_user
      @unpublished = @from_user.discussions.unpublished
    end
  end

  # GET /discussions/1
  # GET /discussions/1.json
  def show
    @published_positions = @discussion.positions.where.not(body: nil)
    @unpublished_positions = @discussion.positions.where(body: nil)
  end

  def publish
    @discussion.publish!
    redirect_to discussion_path(@discussion), flash:{notice: "Published!"}
  end

  # GET /discussions/new
  def new
    @discussion = Discussion.new
  end

  # GET /discussions/1/edit
  def edit
  end

  # POST /discussions
  # POST /discussions.json
  def create
    @discussion = Discussion.new(discussion_params)
    @discussion.user = @user
    respond_to do |format|
      if @discussion.save
        format.html { redirect_to @discussion, notice: 'Discussion was successfully created.' }
        format.json { render :show, status: :created, location: @discussion }
      else
        format.html { render :new }
        format.json { render json: @discussion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /discussions/1
  # PATCH/PUT /discussions/1.json
  def update
    respond_to do |format|
      if @discussion.update(discussion_params)
        format.html { redirect_to @discussion, notice: 'Discussion was successfully updated.' }
        format.json { render :show, status: :ok, location: @discussion }
      else
        format.html { render :edit }
        format.json { render json: @discussion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discussions/1
  # DELETE /discussions/1.json
  def destroy
    @discussion.destroy
    respond_to do |format|
      format.html { redirect_to discussions_url, notice: 'Discussion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_discussion
    @discussion = Discussion.find(params[:id])
  end

  def set_votable
    set_discussion
    @votable=@discussion
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def discussion_params
    params.require(:discussion).permit(:header, :body, :discussion_type_id, :topic_id)
  end
end
