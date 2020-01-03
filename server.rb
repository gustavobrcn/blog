require "sinatra"
require "sinatra/activerecord"
require './models'

set :port, 3000
set :database, {adapter: 'sqlite3', database: './smash_blog.sqlite3'}
enable :sessions

get '/' do 
    erb :signup
end

get '/signup' do
    erb :signup
end

get '/login' do
    erb :login
end


post '/login' do
    user = User.find_by(email: params[:email])
    given_password = params[:password]
    if user.password == given_password
        session[:user_id] = user.id
        redirect '/profile'
    else
    end
end



post '/signup' do
    @user = User.new(params[:user])
    if @user.valid?
        @user.save
        redirect '/profile'
    else
        flash[:error] = @user.errors.full_messages
        redirect '/signup'
    end
    p params
end

get '/profile' do
    redirect '/' unless session[:user_id]
    erb :profile
end