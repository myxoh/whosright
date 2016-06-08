class CommentsController < ApplicationController
  include VotableController
  before_action :get_user_or_redirect
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :set_parent, only: [:index, :create, :get_all]
  
  def index
  end


  def create
    comment = @parent.comments.new(comment_params)
    comment.user = @user
    
    if comment.save
      flash[:notice] = "Comment created"
    else
      flash[:error] = "There was an error creating your comment"
    end
    redirect_to comment.container
  end

  def show
  end

  def destroy
  end
  
  def get_all
    render @parent.all_comments, layout: false
  end
  
  private
  def comment_params
    params.require(:comment).permit(:body)
  end
  
  def set_comment
    @comment = Comment.find(params[:id])
  end
  
  def set_votable
    set_comment
    @votable = @comment
  end
  
  def set_parent
    potential_parents = (%w[discussion position comment]) \
      .collect{|element| [element + "_id", element.capitalize.safe_constantize] } \
      .to_h                                                                           # Will get a hash with {key: Model} for each possible parent
    parent_params = params.select{|element| potential_parents.include? element}.first # Will get an array with [key, value] from the parent passed in the params 
                                                                                      # where value is the Model id
    @parent = potential_parents[parent_params.first].find(parent_params.last)         # Uses the key from from parent_params to access the Model from potential_parents
                                                                                      # Afterwards calls the find method with the model id from parent_params to get the
                                                                                      # parent row
  end
end
