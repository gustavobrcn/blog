require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"
require './models'

configure :development do
    set :database, {adapter: 'postgresql', database: 'smash_blog'}
end
configure :production do 
    set :database, {url: ENV['DATABASE_URL']}
end
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
    end
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
@post = Post.new(content: params["content"], user_id: session[:user_id], username: session[:username])
    if @post.valid? && session[:user_id]
        @post.save
        redirect "/profile/#{session[:username]}"
    end
end

get '/profile/:username' do
    @user = User.find_by(username: session[:username])
    session[:user_id] = @user.id
    erb :profile
end

# ----------Search for Users----------
post '/user' do
    @searched_user = User.find_by(username: params["searched_user"])
    if @searched_user.active == true
        redirect "/user/#{params["searched_user"]}"
    elsif params["searched_user"] == session[:username]
        redirect '/profile'
    elsif @searched_user.active == false
        redirect "/deactivated/#{params["searched_user"]}"
    end
end
        
get '/user/:searched_user' do
    @searched_user = User.find_by(username: params[:searched_user])
    pp @searched_user
    @user = User.find_by(username: session[:username])
    session[:user_id] = @user.id
    erb :user
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

# ----------Change User Profile Attributes----------
post '/change_username' do
    new_username = params["new_username"]
    given_password = params["password"]
    @user = User.find_by(id: session[:user_id])
    if given_password == @user.password
        @user.update(username: new_username)
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

get "/test" do
    x = [*1..20]
    @posts =[]
    x.each do |num|
        @posts << "Lorem ipsum dolor sit amet consectetur adipisicing elit. Laborum officia eius libero. Sequi, quasi. Saepe explicabo illum, commodi at doloremque corrupti quo harum! Eos temporibus expedita quis cum consequatur inventore." 
    end
    erb :test_profile
end

