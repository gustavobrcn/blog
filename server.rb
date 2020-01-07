require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"
require './models'

set :port, 3000
set :database, {adapter: 'postgresql', database: 'smash_blog'}
enable :sessions

get '/signup' do 
    erb :signup
end

post '/signup' do
    @user = User.new(params[:user])
    if @user.valid?
        @user.save
        session[:user_id] = @user.user_name
        redirect '/profile'
    else
        puts flash[:error] = @user.errors.full_messages
        redirect '/signup'
    end
    puts params["confirm_password"]
    erb :profile
end

get '/' do
    erb :login
end

post '/' do
    @user = User.find_by(username: params["username"])
    given_password = params["password"]
    if @user.password == given_password
        session[:user_id] = @user.username
        pp session[:user_id]
        redirect '/profile'#("/profile/#{session[:user_id]}")
    else
        redirect '/login'
    end
    erb :profile
end

get '/profile' do
    # redirect '/' unless session[:user_id]
    erb :profile
end

post '/profile' do
    # @user = User.find_by(username: session[:user_id])
    # @user.update(posts: params["post"])
    @posts = Posts.new(session[:user_id], params["posts"])
    if @posts.valid?
        @posts.save
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

