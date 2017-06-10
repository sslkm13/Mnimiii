class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like, :unlike]
  before_action :owned_post, only: [:edit, :update, :destroy]
  impressionist actions: [:show,:index], unique: [:session_hash]

  def index
    @posts = Post.all.order('created_at DESC').paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.js { render 'posts/post_page' }
    end
  end

  def show
    impressionist(@post)
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:success] = "Your post has been created!"
      redirect_to posts_path
    else
      flash[:alert] = "Your new post couldn't be created!  Please check the form."
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:success] = "Post updated."
      redirect_to posts_path
    else
      flash.now[:alert] = "Update failed.  Please check the form."
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path
  end

  def like
  if @post.liked_by current_user
    create_notification @post
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  def unlike
    if @post.unliked_by current_user
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  def hashtags
    @tag = Tag.find_by(name: params[:name])
    @posts = @tag.posts
  end

  private

  def post_params
    params.require(:post).permit(:image, :caption, :mp3)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def owned_post
    unless current_user == @post.user
      redirect_to root_path
    end
  end

  def create_notification(post)
    return if post.user == current_user
    Notification.create(user_id: post.user.id,
                        notified_by_id: current_user.id,
                        post_id: post.id,
                        identifier: post.id,
                        notice_type: 'like')
  end

end
