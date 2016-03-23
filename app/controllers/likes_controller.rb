class LikesController < ApplicationController

   def create
      post = Post.find( params[:post_id] )
      like = Like.new( post: post, user: current_user )

      like.save

      redirect_to posts_path
   end

end
