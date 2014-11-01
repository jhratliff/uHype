class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def index
    @comments = Comment.order(id: :desc).all
    respond_with(@comments)
  end

  def show
    respond_with(@comment)
  end

  def new
    @comment = Comment.new
    respond_with(@comment)
  end

  def edit
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.save
    respond_with(@comment)
  end

  def update
    @comment.update(comment_params)
    respond_with(@comment)
  end

  def destroy
    @comment.destroy
    respond_with(@comment)
  end



  def flag
    @user = current_user
    if params[:comment_id]
      @user.flagged_comments << Comment.find(params[:comment_id])
    end
    @comment = Comment.find(params[:comment_id])
  end

  def unflag
    @user = current_user
    if params[:comment_id]
      @user.flagged_comments.destroy(Comment.find(params[:comment_id]))
    end
    @comment = Comment.find(params[:comment_id])
  end


  def like
    @user = current_user
    if params[:comment_id]
      @user.liked_comments << Comment.find(params[:comment_id])
    end
    @comment = Comment.find(params[:comment_id])
  end

  def unlike
    @user = current_user
    if params[:comment_id]
      @user.liked_comments.destroy(Comment.find(params[:comment_id]))
    end
    @comment = Comment.find(params[:comment_id])
  end

  def dislike
    @user = current_user
    if params[:comment_id]
      @user.unliked_comments << Comment.find(params[:comment_id])
    end
    @comment = Comment.find(params[:comment_id])
  end

  def undislike
    @user = current_user
    if params[:comment_id]
      @user.unliked_comments.destroy(Comment.find(params[:comment_id]))
    end
    @comment = Comment.find(params[:comment_id])
  end



  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:user_id, :school_id, :detail, :flag_count, :like_count, :unlike_count)
    end
end
