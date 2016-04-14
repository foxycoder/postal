Web Application where Users make posts and like other user's posts.

Purpose: Illustrate building an application with Users & Authentication from Devise.

For later reference, complete source can be found on github at [https://github.com/gandjhar/postal](https://github.com/gandjhar/postal)

<br>
<img src="http://cd.sseu.re/postal/like-post.png" width="600px" />

## Rails New

Create a new application called **postal**.

```
> rails new postal
```

## Posts Model

Create a Posts model

```
> rails generate model Post content:text
> rake db:migrate
```

## Seeds

Make some seed Posts.

`db/seeds.rb`

```ruby
Post.delete_all

Post.create( content: "Pizza is yummy!"                    )
Post.create( content: "Veggies are tasty and nutritious."  )
Post.create( content: "Salt is the best ingredient."       )

Post.create( content: "I've seen Star Wars 23 times."      )
Post.create( content: "Walking Dead has an exciting plot." )
Post.create( content: "I only watch art-house films."      )

Post.create( content: "My cats are cute!"      )
Post.create( content: "Dogs are good friends."  )
Post.create( content: "My hamster resents me." )

Post.create( content: "Free market solves all problems."         )
Post.create( content: "Workers control the means of production." )
Post.create( content: "Can't we all just get along?"             )
```

Seed the Db.

```
> rake db:seed
```

## Feed of Posts

Make an index view of posts.  

Generate controller.

```
> rails g controller Posts index
```

Implement index action

`app/controllers/post_controller.rb`

```ruby
class PostsController < ApplicationController

  def index
     @posts = Post.all
  end

end
```

View to list the posts

`app/views/posts/index.html.erb`

```html
<%= render @posts %>
```

`app/views/posts/_post.html.erb`

```html
<p><%= post.content %></p>
```

Add Posts resource to routes

`config/routes.rb
`

```ruby
Rails.application.routes.draw do

  resources :posts

end
```

<img src="http://cd.sseu.re/postal/posts-index.png" width="600px" />

## Bootstrap

Add Bootstap to make app look nice.

`Gemfile`

```ruby
# ...
gem 'bootstrap-sass', '~> 3.3.6'
```

`app/assets/stylesheets/application.scss [note extension changed from .css to .scss]`

```ruby
# ...
@import "bootstrap-sprockets";
@import "bootstrap";
```

`app/assets/javascript/application.js`

```ruby
# ...
//= require bootstrap-sprockets
```

## Nav Bar

Nav bar with Logo.

`app/views/layouts/_header.html.erb`

```html
<header class="navbar navbar-fixed-top navbar-default">
  <div class="container">
    <%= link_to "Postal", '/', class: "navbar-brand" %>
    <nav>
      <ul class="nav navbar-nav">
        <li><%= link_to "Posts", posts_path %></li>
      </ul>
    </nav>
  </div>
</header>
```

Render the header in the layout.

`app/views/layouts/application.html.erb`

```html
# ...
<body>

<%= render "layouts/header" %>

<main class="container">
   <%= yield %>
</main>

</body>
```

Styling to push main down on the page, out from under the nav bar.

`app/assets/stylesheets/application.scss`

```css
main {
   padding-top: 80px;
}
```

<img src="http://cd.sseu.re/postal/posts-bootstrap.png" width="600px" />

## New Post Form

Create a form to add new Post.

`app/views/posts/_form.html.erb`

```html
<%= form_for Post.new do |f| %>
    <div class="input-group col-xs-12">
      <div class="col-xs-8"><%= f.text_field :content, class: "form-control" %></div>
      <div class="col-xs-4"><%= f.submit "Create", class: "btn" %></div>
    </div>
<% end %>
```

Add the form to the index view so that it appears above the old posts.

`app/views/posts/index.html.erb`

```html
<%= render "form" %>
<br>

<%= render @posts %>
```

Also position the posts to align with form.

`app/views/posts/_post.hmtl.erb`

```html
<div class="col-xs-8">
   <p><%= post.content %></p>
</div>
```

Controller method to create new post.

```ruby
class PostsController < ApplicationController

  def create
     post_params = params.require( :post ).permit( :content )

     @post = Post.new( content: post_params[:content] )

     if @post.save
        redirect_to posts_path
     else
        render posts_path
     end
  end

end
```

Can now add new posts!

<img src="http://cd.sseu.re/postal/new-post.png" width="600px" />

## Post Order

Order posts so that most recent appears on top.

```ruby
class PostsController < ApplicationController

  def index
     @posts = Post.order( created_at: :desc )
  end

end
```

## Devise

Add Devise

`Gemfile`

```
# ...

gem 'devise', '~> 3.5'
```

Install

```
> bundle install
> rails generate devise:install
```

Create User model.

```
> rails generate devise User
> rake db:migrate
```

## Seed Users

Seed some users.

`db/seeds.rb`

```ruby
User.delete_all

frank = User.create( email: 'frank@ex.com', password: 'abcd1234', password_confirmation: 'abcd1234' )
alice = User.create( email: 'alice@ex.com', password: 'abcd1234', password_confirmation: 'abcd1234' )
anton = User.create( email: 'anton@ex.com', password: 'abcd1234', password_confirmation: 'abcd1234' )
```

## Log-in

Add log in/out links to the nav bar.

`app/views/layouts/_header.html.erb`

```html
<nav>
  <ul class="nav navbar-nav">
    <li><%= link_to "Posts", posts_path %></li>
  </ul>
  <ul class="nav navbar-nav navbar-right">
    <% if !user_signed_in? %>
        <li><%= link_to "Log In", new_user_session_path %></li>
    <% else %>
        <li><span class="navbar-text"><%= current_user.email %></span></li>
        <li><%= link_to "Log Out", destroy_user_session_path, :method => :delete %></li>
  <% end %>
  </ul>
</nav>
```

Log in option now on right of nav bar.

<img src="http://cd.sseu.re/postal/log-in-link.png" width="600px" />

Log in takes user to log in form from Devise.

<img src="http://cd.sseu.re/postal/log-in-form.png" width="600px" />

Now logged in.  Current user and log out option displayed in nav bar.

<img src="http://cd.sseu.re/postal/logged-in.png" width="600px" />


## User Posts

Each post should be from a user.  

Add a user column to the posts table.

```
> rails generate migration AddUserToPosts user:references
```

Creates the migration

`db/migrate/20160323120424_add_user_to_posts.rb`

```ruby
class AddUserToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :user, index: true, foreign_key: true
  end
end
```

Migrate the database.

```
> rake db:migrate
```

## Post/User Relationship

Add user-posts relationship to the models.

`app/models/post.rb`

```ruby
class Post < ActiveRecord::Base
   belongs_to :user
end
```

`app/models/user.rb`

```ruby
class User < ActiveRecord::Base
  has_many :posts
end
```

## Seed User Posts

Add user to each seed post.

`db/seeds.rb`

```ruby
Post.create( content: "Pizza is yummy!"                   , user: frank )
Post.create( content: "Veggies are tasty and nutritious." , user: alice )
Post.create( content: "Salt is the best ingredient."      , user: anton )

Post.create( content: "I've seen Star Wars 23 times."      , user: frank )
Post.create( content: "Walking Dead has an exciting plot." , user: alice )
Post.create( content: "I only watch art-house films."      , user: anton )

Post.create( content: "My cats are cute!"      , user: frank )
Post.create( content: "Dogs are good friends." , user: alice )
Post.create( content: "My hamster resents me." , user: anton )

Post.create( content: "Free market solves all problems."         , user: frank )
Post.create( content: "Workers control the means of production." , user: alice )
Post.create( content: "Can't we all just get along?"             , user: anton )
```

## Show User Post

Display User Name with each Post.

Use front of email as a user's 'handle'.

```ruby
class User < ActiveRecord::Base
  def handle
    self.email.split('@')[0]
  end
end
```

`app/views/posts/_post.html.erb`

```html
<div class="col-xs-8">
   <p>
      <h4><%= post.content %></h4>
      <em>
        <%= post.user.handle %>
      </em>
   </p>
</div>
```

<img src="http://cd.sseu.re/postal/user-posts.png" width="600px" />

## Require Log-in to Post

Only show the new post form if logged in.

`app/views/posts/index.html.erb`

```html
<% if user_signed_in? %>
   <%= render "form" %>
   <br>
<% end %>

<%= render @posts %>
```

## User Posts

New Posts should be attributed to current user

```ruby
class PostsController < ApplicationController

  def create
     # ...  
     @post = Post.new( content: post_params[:content], user: current_user )
     # ...
  end

end
```

## User's Posts

Add a page for an individual User's Posts.

Controller action

```ruby
class PostsController < ApplicationController

   # ...

   def user
      @user = User.find( params[:user_id] )

      @posts = Post.where( user: @user ).sort_by { |post| post.created_at }.reverse
   end
end
```

View

`app/views/posts/user.html.erb`

```html
<h1><%= @user.handle %></h1>

<br>

<% @posts.each do |post| %>
   <h4><%= post.content %></h4>
<% end %>
```

Route

```ruby
Rails.application.routes.draw do

   # ...

   get 'user_posts/:user_id' => 'posts#user', as: :user_posts
end
```

Link users in main index list to their list of posts.

`app/views/posts/_post.html.erb`

```html
<div class="col-xs-8">
   <p>
      <h4><%= post.content %></h4>
      <em>
        <%= link_to post.user.handle, user_posts_path( post.user ) %>
      </em>
   </p>
</div>
```

<img src="http://cd.sseu.re/postal/users-posts.png" width="600px" />

# Liking

Add ability for User to like posts.

## Like Model

Generate a model for Likes.

```
> rails g model Like post:references user:references
```

Post has many Likes

`app/models/post.rb`

```ruby
class Post < ActiveRecord::Base
   belongs_to :user
   has_many :likes
end
```

Like belongs to User and Post.

`app/models/like.rb`

```ruby
class Like < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
end
```

## Like Controller

Generate a controller for likes.

```
> rails generate controller Likes
```

Create Like action.  

Note that the new like is attributed to the current user.

`app/controllers/likes.rb`

```ruby
class LikesController < ApplicationController

   def create
      post = Post.find( params[:post_id] )
      like = Like.new( post: post, user: current_user )

      like.save

      redirect_to posts_path
   end

end
```

Nest routes

```ruby
Rails.application.routes.draw do

  resources :posts  do
    resources :likes
  end

end
```

Add like button with count to each Post.  
- Button is disabled if user is not signed in.  
- Button is yellow if liked by current user.

`app/views/posts/_post.html.erb`

```ruby
<div class="col-xs-8">
   <p>
      <h4><%= post.content %></h4>

      <% liked = Like.find_by( post: post, user: current_user ) != nil %>
      <% btn_color = liked ? "warning" : "default" %>

      <%= link_to "ツ", post_likes_path( post ), method: :post, class: "btn btn-#{btn_color} btn-xs", disabled: !user_signed_in? %>
      <%= post.likes.count %>

      &nbsp

      <em><%= link_to post.user.handle, user_posts_path( post.user ) %></em>
   </p>
</div>
```

<img src="http://cd.sseu.re/postal/like-post.png" width="600px" />

## Unlike

Button toggles like/unlike.

```ruby
class LikesController < ApplicationController

   def create
      post = Post.find( params[:post_id] )

      if like = Like.find_by( post: post, user: current_user )
         like.destroy
      else
         like = Like.new( post: post, user: current_user )
         like.save
      end

      redirect_to posts_path
   end

end
```

## User Likes

Add to User view a display of posts that a user likes.

Model

`app/models/user.rb`

```ruby
class User < ActiveRecord::Base
   # ...
   has_many :likes
end
```

Add user action to Post Controller.

```ruby
class PostsController < ApplicationController

  def user
     @user = User.find( params[:user_id] )

     @posts = Post.where( user: @user ).sort_by { |post| post.created_at }.reverse

     @likes = @user.likes.sort_by { |like| like.post.created_at }.reverse
  end

end
```

View of User's posts.

`app/views/posts/user.html.erb`

```html+erb
<h1><%= @user.handle %></h1>
<br>

<% @posts.each do |post| %>
   <h4><%= post.content %></h4>
<% end %>
<br>

<h1>likes</h1>
<br>

<% @likes.each do |like| %>
   <% if like.post.user_id != @user.id %>
      <h4><%= like.post.content %></h4>
   <% end %>
<% end %>
```

<img src="http://cd.sseu.re/postal/user-likes.png" width="600px" />
