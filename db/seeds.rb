Post.delete_all
User.delete_all

frank = User.create( email: 'frank@ex.com', password: 'abcd1234' )
alice = User.create( email: 'alice@ex.com', password: 'abcd1234' )
anton = User.create( email: 'anton@ex.com', password: 'abcd1234' )

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
