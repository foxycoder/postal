class LikesController < ApplicationController

   def create
      post = Post.find( params[:post_id] )
      like = Like.new( post: post, user: current_user )

      if like.save
         redirect_to posts_path
      else
         render posts_path
      end
   end

end
