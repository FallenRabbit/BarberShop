require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

configure do
  enable :sessions
end

helpers do
  def username
      session[:identity] ? session[:identity] : 'Hello stranger'     

end
end


before '/secure/*' do
  
  
  unless session[:identity]
      session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in with password ' + request.path
    halt erb(:login_form)
end
end

get '/' do
   halt erb (:table)
   # erb :table1
   # erb 'Can you handle a <a href="/secure/place">secret</a>?'
  
end
get '/visit' do
 
  erb :visit
end


get '/about' do
  erb :about
end

post '/about' do
@nu = params[:user_name]

erb "adkjaskdj #{@nu}"
end

get '/login/form' do
  erb :login_form
end


post '/' do
  if params[:user_name]==''
    @user_name = session[:identity]
    
  else
    @user_name = params[:user_name]
  end
  
  @phone = params[:phone_number]
  @date = params[:date]
  @barber = params[:barber]


  info = "#{@user_name} #{@phone} #{@date} #{@barber}\n"
  f = File.open '.\public\visit.txt','a'
  f.write info
  f.close

  erb :visit
  erb "<center><h3><b>Шановний <%=@user_name%>!!!</font></b></h4> <h4>Ви записані до <%=@barber%></h4> <h4>Ми передвзонимо Вам на телефон: <%=@phone%></h4>  <h4><%=@date%>За декілька годин до <%=@date%> !!</h4></center>"
end

post '/login/attempt' do
  session[:identity] = params['username'] if  params['password'] == 'nube'
  @where_user_came_from = session[:previous_url] || '/'
  redirect to @where_user_came_from
erb "<div class='alert alert-message'>Wrong password</div>"

end

get '/logout' do
  if session.delete(:identity) !=nil
  erb "<div class='alert alert-message'>Logged out</div>"
else
  redirect to '/'
end
end

get '/secure/place' do
  erb 'This is a secret place that only <%=session[:identity]%> has access to!'
end
