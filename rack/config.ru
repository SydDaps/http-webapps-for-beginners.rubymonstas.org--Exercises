class Application
  def call(env)
    status  = 200
    headers = { "Content-Type" => "text/html" }
    body    = ["<html><body><h1>Yay, your first web application! <3</h1></body></html>"]
    
    [status, headers, body]
  end
end

run Application.new