require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'sinatra/activerecord'
require './models'
require 'pry'

require 'open-uri'
require 'sinatra/json'

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user])
  end
end

before do
  Dotenv.load
  Cloudinary.config do |config|
    config.cloud_name = ENV['CLOUD_NAME']
    config.api_key    = ENV['CLOUDINARY_API_KEY']
    config.api_secret = ENV['CLOUDINARY_API_SECRET']
  end
end

# before do
#   unless current_user.nil?
#     redirect '/signin'
#   end
# end

# after do
#   logger.info "#{current_user.name}がログイン"
# end



get '/' do
  if current_user.nil?
    redirect '/signin'
  end
  @contents = Contribution.all.order('id desc')
  erb :index
end

get '/signup' do
  erb :sign_up
end

post '/signup' do
  user = User.create(
  name: params[:name],
  email: params[:email],
  password: params[:password],
  password_confirmation: params[:password_confirmation],
  theme: params[:theme]
  )
  
  if user.persisted?
    session[:user] = user.id
  end
  redirect '/'
end

get '/signin' do
  erb :sign_in
end

post '/signin' do
  user = User.find_by(email: params[:email])
  if user && user.enabled == true && user.authenticate(params[:password])
    session[:user] = user.id
  end
  redirect '/'
end

get '/signout' do
  session[:user] = nil
  redirect '/'
end

get '/withdrawal' do
  user = User.find(session[:user])
  user.update({
    enabled: false
  })
  session[:user] =nil
  flash[:danger] ="退会しました"
  redirect '/'
end

post '/new' do
  img_url = ''
  if params[:file]
    img = params[:file]
    tempfile = img[:tempfile]
    upload = Cloudinary::Uploader.upload(tempfile.path)
    img_url = upload['url']
  end
  
  Contribution.create({
    title: params[:title],
    body: params[:body],
    img: img_url
  })
  
  redirect '/'
end

post '/delete/:id' do
  Contribution.find(params[:id]).destroy
  redirect '/'
end

get '/edit/:id' do
  @content = Contribution.find(params[:id])
  erb :edit
end

post '/renew/:id' do
  content = Contribution.find(params[:id])
  content.update({
    title: params[:title],
    body: params[:body]
  })
  redirect '/'
end

get '/setting' do
  erb :setting
end
