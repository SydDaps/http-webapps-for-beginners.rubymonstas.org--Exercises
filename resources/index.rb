require "sinatra"
set :port, 4000
require "erb"
enable :sessions
use Rack::MethodOverride

def addMember(fileName, name)
  File.open(fileName, "a+") do |file|
    file.puts(name)
  end
end

def readMembers(fileName)
  return [] unless File.exist?("members.txt")
  File.read(fileName).split("\n")
end

def updateMember(fileName, name, newName)
  data = File.read(fileName)
  File.open(fileName, "w") do |f|
    f.write(data.gsub(name, newName))
  end
  
end

get "/members" do 
  @members = readMembers("members.txt")
  erb :index
end

get "/members/:name" do 
  @name = params[:name]
  if @name == "new"
    erb :newMember
  else
    @message = session.delete(:message)
    erb :show
  end
end

post "/members" do 
  @name = params[:name]
  if @name.to_s.empty?
    @message = "Bro we need a name"
    erb :newMember
  elsif readMembers("members.txt").include?(@name)
    @message = "Yawa the name already dey"
    erb :newMember
  else 
    addMember("members.txt", @name)
    session[:message] = "Welcome to the gang"
    redirect "/members/#{@name}"
  end
end

get "/members/:name/edit" do
  @name = params[:name]
  erb :editMember
end

put "/members/:name" do 
  @name = params[:name]
  @newName = params[:newName]

  if @newName.to_s.empty?
    @message = "Bro we need a name"
    erb :editMember
  elsif readMembers("members.txt").include?(@newName)
    @message = "Yawa the name already dey"
    erb :editMember
  else
    updateMember("members.txt", @name, @newName)
    session[:message] = "Killer we change the name oo from #{@name} to #{@newName}"
    redirect "/members/#{@newName}"
  end

end

get  "/members/:name/delete" do
  @name = params[:name]
  erb :delete
end

delete "/members/:name" do
  @name = params[:name]
  updateMember("members.txt", @name, "")

  redirect "/members"
end