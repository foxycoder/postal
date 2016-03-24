class PostsController < ApplicationController

  def index
     @posts = Post.all.sort_by { |post| post.created_at }.reverse
  end

  def create
     post_params = params.require( :post ).permit( :content )

     @post = Post.new( content: post_params[:content], user: current_user )

     if @post.save
        redirect_to posts_path
     else
        render posts_path
     end
  end

  def user
     @user = User.find( params[:user_id] )

     @posts = Post.where( user: @user ).sort_by { |post| post.created_at }.reverse

     @likes = @user.likes.sort_by { |like| like.post.created_at }.reverse
  end

end
