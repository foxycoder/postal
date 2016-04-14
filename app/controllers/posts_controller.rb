class PostsController < ApplicationController

  def index
     @posts = Post.order( created_at: :desc )
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

     @posts = Post.where( user: @user ).order( created_at: :desc )

     @likes = @user.likes.sort_by { |like| like.post.created_at }.reverse
  end

end
