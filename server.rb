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
        redirect "/profile/#{session[:username]}"
    else
        puts flash[:error] = @user.errors.full_messages
        redirect '/signup'
    end
    puts params["confirm_password"]
    erb :profile
end


#----------Main Page and log in----------
get '/login' do
    redirect '/'
end

get '/' do
    erb :login
end

post '/login' do
    @user = User.find_by(username: params["username"])
    given_password = params["password"]
    if @user.active == false
        redirect '/reactivate'
    elsif @user.password == given_password && @user.active
        session[:username] = @user.username
        session[:user_id] = @user.id
        redirect "/profile/#{params["username"]}"
    else
        redirect '/login'
    end
    erb :profile
end


# ----------Making Posts on Profile----------
post '/profile' do
@post = Post.new(content: params["content"], user_id: session[:user_id])
    if @post.valid? && session[:user_id]
        @post.save
        redirect "/profile/#{session[:username]}"
    end
end

get '/profile/:username' do
    @user = User.find_by(username: session[:username])
    session[:user_id] = @user.id
    # @user.friends.each
    # @friends = Friend.where(user_id: session[:user_id])
    erb :profile
end

# ----------Search for Users----------
post '/user' do
    @searched_user = User.find_by(username: params["searched_user"])
    session[:searched_user] = @searched_user.username
    if @searched_user.active == true
        redirect "/user/#{params["searched_user"]}"
    elsif params["searched_user"] == session[:username]
        redirect '/profile'
    elsif @searched_user.active == false
        redirect "/deactivated/#{session[:searched_user]}"
        
    end
end

get '/user/:serched_user' do
    pp :searched_user
    @searched_user = User.find_by(username: session[:searched_user])
    erb :user
end

# ----------Add Friend----------
post '/add_friend' do
    @added_friend = Friend.new(user_id: session[:user_id], friend: session[:searched_user])
    @added_friend.save
    redirect "/profile/#{session[:username]}"
end

# ---------- The Hub ----------
get '/hub' do
    @posts = Post.all
    erb :hub
end

# ----------User Account----------
get '/account/:username' do
    @user = User.find_by(id: session[:user_id])
    erb :account
end

# ----------Change User Profile----------
post '/account' do
    user = User.find_by(id: session[:user_id])
    erb :account
end

post '/change_username' do
    new_username = params["new_username"]
    given_password = params["password"]
    @user = User.find_by(id: session[:user_id])
    @friend = Friend.find_by(friend: session[:username])
    if @friend == nil
        @friend = Friend.new(user_id: nil, friend: new_username)
    end
    if given_password == @user.password
        @user.update(username: new_username)
        @friend.update(friend: new_username)
        session[:username] = @user.username
        redirect "/profile/#{session[:username]}"
    end
end

post '/change_password' do
    @user = User.find_by(id: session[:user_id])
    current_password = params["current_password"]
    new_password = params["new_password"]
    confirm_password = params["confirm_password"]
    if current_password == @user.password && new_password == confirm_password
        @user.update(password: new_password)
        redirect "/profile/#{session[:username]}"
    end
end

post '/disable_account' do
    @user = User.find_by(id: session[:user_id])
    given_password = params["password"]
    confirm_password = params["confirm_password"]
    if given_password == confirm_password && given_password == @user.password
        @user.update(active: false)
        redirect '/logout'
    end
end

# ----------Reactivate User----------
post '/reactivate' do 
    @user = User.find_by(username: params["username"])
    reactivate_user = params["username"]
    given_password = params["password"]
    if  reactivate_user == @user.username && given_password == @user.password
        @user.update(active: true)
        redirect '/' 
    end
end

get '/reactivate' do
    erb :reactivate
end

# ----------Deactivated User Page----------
get '/deactivated/:searched_user' do
    erb :deactivated
end

# ----------Log out----------
get '/logout' do
    session[:username] = nil
    session[:user_id] = nil
    redirect '/login'
end



# $mains = ["Banjo & Kazooie", "Bayonetta", "Bowser", "Bowser Jr.", "Captain Falcon", "Charizard", "Chrom", "Cloud", "Corrin", "Daisy", "Dark Pit", "Dark Samsus", "Diddy Kong", "Donky Kong", "Dr. Mario", "Duck Hunt", "Falco", "Fox", "Ganondorf", "Greninja", "Hero", "Ice Climbers", "Ike", "Incineror", "Inkling", "Isabelle", "Ivysaur", "Jigglypuff", "Joke", "Ken", "King DeDe", "King K. Rool", "Kirby", "Link", "little Mac", "Lucario", "Lucas", "Lucina", "Luigi", "Mario", "Marth", "Mega Man", "Meta Knight", "Mewtwo", "Mii Brawler", "Mii Gunner", "Mii Swordfighter", "Mr. Game & Watch", "Ness", "Olimar", "Pac-Man", "Palutena", "Peach", "Pichu", "Pikachu", "Piranha Plant", "Pit", "Pokemon Trainer", "R.O.B.", "Richter", "Ridley", "Robin", "Rosalina & Luna", "Roy", "Ryu", "Samus", "Sheik", "Shulk", "Simon", "Snake", "Sonic", "Squirtle", "Terry", "Toon Link", "Villager", "Wario", "Wii Fit Trainer", "Wolf", "Yoshi", "Young Link", "Zelda", "Zero Suit Samus"]

