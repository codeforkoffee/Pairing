class PostsController < ApplicationController
  before_filter :authenticate_user!
  before_action :find_post

  def index
    @posts = Post.all
  end

  def new
    @users = User.all_except(current_user)
    @post = Post.new(params[:post])
    @reciever_id = params[:sender_id]
  end

  def create
    @post = Post.new
    byebug
    if @post.save(post_params)
      flash[:notice] = "Successfully created post!"
      redirect_to post_path(@post)
    else
      flash[:alert] = "Error creating new post!"
      render :new
    end
  end

  def show
    # byebug
    @posts_title = Post.find(params[:id]).title
    @posts_content = Post.find(params[:id]).content
    #will display a single post
    if Post.exists?(current_user.id)
      @posts = Post.find(params[:id])
      render :show
    else
      # render :new
    end
  end

  def edit
  end

  def update
    if @post.update_attributes(post_params)
      flash[:notice] = "Successfully updated post!"
      redirect_to post_path(@posts)
    else
      flash[:alert] = "Error updating post!"
      render :edit
    end
  end

  def destroy
    if @post.destroy
      flash[:notice] = "Successfully deleted post!"
      redirect_to post_path
    else
      flash[:alert] = "Errors deleting post!"
    end
  end
end

private

def post_params
  params.require(:post).permit(:title, :admin_message, :content, :sender_id, :recipient_id, :rating)
end

def find_post
  @post = Post.find_by_id(params[:id])
end
