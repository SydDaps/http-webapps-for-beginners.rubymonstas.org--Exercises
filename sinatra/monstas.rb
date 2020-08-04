require "sinatra"
set :port, 4000
require "erb"
enable :sessions


get "/" do
  "OMG, hello Ruby Monstas!"
end

get "/hey" do
  "Hey Mama "
end

get "/test/:name" do 
  erb :temp, { :locals => params, :layout => :layout }
end

def store_name(fileName, string)
  File.open(fileName, "a+") do |file|
    file.puts(string)
  end
end

def read_names(fileName)
  return [] unless File.exist?("names.txt")
  File.read(fileName).split("\n")
end
get "/form" do 
  @message = session.delete(:message)
  @name = params["name"]
  @names = read_names("names.txt")
  erb :form

end

class NameValidator
  attr_accessor :name, :allNames, :message
  def initialize(name, allNames)
    @name = name.to_s
    @allNames = allNames
  end

  def valid?
    validator
    @message.nil?
  end


  private
    def validator 
      if @name.empty? 
        @message = "Please enter a name"
      elsif @allNames.include?(@name)
        @message = "Name already in the list"
      end
    end


end


post "/form" do 
  @name = params["name"]
  @names = read_names("names.txt")

  # if @name.nil? or @name.empty?
  #   session[:message] = "Please enter a valid name."
  # elsif @names.include?(@name)
  #   session[:message] = "Enter a new name Name already in list"
  # else
  #   store_name("names.txt",@name)
  #   session[:message] = "Successfully stored the name #{@name}."
  # end
  validate = NameValidator.new(@name, @names)
  
  if validate.valid?
    store_name("names.txt", @name)
    session[:message] = "Successfully stored the name #{@name}."
    redirect "/form?name=#{@name}"
  else 
    @message = validate.message
    erb :form
  end


 
end
