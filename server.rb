require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"
require './models'

set :port, 3000
# set :database, {adapter: 'sqlite3', database: './smash_blog.sqlite3'}
set :database, {adapter: 'postgresql', database: 'smash_blog'}
enable :sessions

get '/signup' do 
    erb :signup
end

post '/signup' do
    @user = User.new(params[:user])
    if @user.valid? & params[:password] == params["confirm_password"]
        @user.save
        redirect '/profile'
    else
        puts flash[:error] = @user.errors.full_messages
        redirect '/signup'
    end
    puts params[:password]
    erb :profile
end

post '/login' do
    user = User.find_by(username: params[:username])
    given_password = params[:password]
    if user.password == given_password
        session[:user_id] = user.id
        redirect '/profile'
    else
    end
end

get '/profile' do
    # redirect '/' unless session[:user_id]
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

