require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"
require './models'

set :port, 3000
set :database, {adapter: 'postgresql', database: 'smash_blog'}
enable :sessions


# ----------Sign Up----------
get '/signup' do 
    erb :signup
end

post '/signup' do
    @user = User.new(params[:user])
    if @user.valid?
        @user.save
        session[:username] = @user.username
        session[:user_id] = @user.id
        redirect '/profile'
    else
        puts flash[:error] = @user.errors.full_messages
        redirect '/signup'
    end
    puts params["confirm_password"]
    erb :profile
end


#----------Main Page and log in----------
get '/' do
    erb :login
end

post '/login' do
    @user = User.find_by(username: params["username"])
    given_password = params["password"]
    if @user.password == given_password
        session[:username] = @user.username
        pp session[:username]
        pp @user.id
        redirect "/profile"
    else
        redirect '/login'
    end
    erb :profile
end


# ----------Making Posts on Profile----------
get '/profile' do
    puts params
    puts session
    @user = User.find_by(username: session[:username])
    pp @user
    session[:user_id] = @user.id
    # @user_posts = Post.where(user_id: session[:user_id]).order(created_at: :desc)
    erb :profile
end

post '/profile' do
    @user = User.find_by(username: session[:username])
    session[:user_id] = @user.id
    @post = Post.new(content: params["content"], user_id: @user.id)
    if @post.valid?
        @post.save
        # @user_posts = Posts.where(user_id: session[:user_id]).order(created_at: :desc)
        # pp @user_posts
        pp "this is from the post request"
        redirect "/profile"
    end
    erb :profile
end


get '/logout' do
    session[:username] = nil
    session[:user_id] = nil
    # erb :login
    redirect '/'
end


get '/settings/:username' do
    erb :settings
end

post '/delete_account' do
    user = User.find_by(params['user_name'])
    user.destroy
    erb :signup
end


get '/feed' do
    @posts = Post.all
    erb "<% @posts.each do |post| %>
    <%= post.content %>
    <%= post.user.username %>
    <% end %>
    "
end
# post '/profile' do 
#     erb :profile
# end


# $mains = ["Banjo & Kazooie", "Bayonetta", "Bowser", "Bowser Jr.", "Captain Falcon", "Charizard", "Chrom", "Cloud", "Corrin", "Daisy", "Dark Pit", "Dark Samsus", "Diddy Kong", "Donky Kong", "Dr. Mario", "Duck Hunt", "Falco", "Fox", "Ganondorf", "Greninja", "Hero", "Ice Climbers", "Ike", "Incineror", "Inkling", "Isabelle", "Ivysaur", "Jigglypuff", "Joke", "Ken", "King DeDe", "King K. Rool", "Kirby", "Link", "little Mac", "Lucario", "Lucas", "Lucina", "Luigi", "Mario", "Marth", "Mega Man", "Meta Knight", "Mewtwo", "Mii Brawler", "Mii Gunner", "Mii Swordfighter", "Mr. Game & Watch", "Ness", "Olimar", "Pac-Man", "Palutena", "Peach", "Pichu", "Pikachu", "Piranha Plant", "Pit", "Pokemon Trainer", "R.O.B.", "Richter", "Ridley", "Robin", "Rosalina & Luna", "Roy", "Ryu", "Samus", "Sheik", "Shulk", "Simon", "Snake", "Sonic", "Squirtle", "Terry", "Toon Link", "Villager", "Wario", "Wii Fit Trainer", "Wolf", "Yoshi", "Young Link", "Zelda", "Zero Suit Samus"]

