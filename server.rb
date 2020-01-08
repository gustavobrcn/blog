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
        session[:username] = @user.user_name
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

post '/' do
    @user = User.find_by(username: params["username"])
    given_password = params["password"]
    if @user.password == given_password
        session[:username] = @user.username
        pp session[:username]
        pp @user.id
        redirect "/profile/#{session[:username]}"
    else
        redirect '/login'
    end
    erb :profile
end


# ----------Making Posts on Profile----------
get '/profile/:username' do
    @user = User.find_by(username: session[:username])
    session[:user_id] = @user.id
    @user_posts = Posts.where(user_id: session[:user_id]).order(created_at: :desc)
    pp @user_posts
    erb :profile
end

post '/profile' do
    pp session[:username]
    @user = User.find_by(username: session[:username])
    session[:user_id] = @user.id
    pp "this is from the post request"
    @post = Posts.new(content: params["content"], user_id: @user.id)
    if @post.valid?
        @post.save
        # @user_posts = Posts.where(user_id: session[:user_id]).order(created_at: :desc)
        # pp @user_posts
        redirect "/profile/#{session[:username]}"
    end
    erb :profile
end


get '/delete_account' do
    erb :delete_account
end

post '/delete_account' do
    user = User.find_by(params['user_name'])
    user.destroy
    erb :signup
end

# post '/profile' do 
#     erb :profile
# end


# $mains = ["Banjo & Kazooie", "Bayonetta", "Bowser", "Bowser Jr.", "Captain Falcon", "Charizard", "Chrom", "Cloud", "Corrin", "Daisy", "Dark Pit", "Dark Samsus", "Diddy Kong", "Donky Kong", "Dr. Mario", "Duck Hunt", "Falco", "Fox", "Ganondorf", "Greninja", "Hero", "Ice Climbers", "Ike", "Incineror", "Inkling", "Isabelle", "Ivysaur", "Jigglypuff", "Joke", "Ken", "King DeDe", "King K. Rool", "Kirby", "Link", "little Mac", "Lucario", "Lucas", "Lucina", "Luigi", "Mario", "Marth", "Mega Man", "Meta Knight", "Mewtwo", "Mii Brawler", "Mii Gunner", "Mii Swordfighter", "Mr. Game & Watch", "Ness", "Olimar", "Pac-Man", "Palutena", "Peach", "Pichu", "Pikachu", "Piranha Plant", "Pit", "Pokemon Trainer", "R.O.B.", "Richter", "Ridley", "Robin", "Rosalina & Luna", "Roy", "Ryu", "Samus", "Sheik", "Shulk", "Simon", "Snake", "Sonic", "Squirtle", "Terry", "Toon Link", "Villager", "Wario", "Wii Fit Trainer", "Wolf", "Yoshi", "Young Link", "Zelda", "Zero Suit Samus"]

