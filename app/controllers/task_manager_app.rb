require 'models/task_manager'

class TaskManagerApp < Sinatra::Base
  set :root, File.join(File.dirname(__FILE__), '..')  # This line sets the root of our project. Here we're taking the current file (app/controllers/task_manager_app) and going one folder up the chain. This should take us to our app folder. The reason we're doing this is
                                                     # because Sinatra will look relative to our app for views and stylesheets. We don't want to put these things in our controller folder, so we're specifying that our root is just app
  get '/' do            # we tell our app that when a get request is sent to the '/' path, it should send back 'hello, world!' as the response.
    #'hello, world!'
    erb :dashboard      # this piece of code will look for an .erb file called 'dashboard' in the views folder at the root of the app. Since we've already set the root of the app and created a views folder there, we're ready to make a dashboard file.
  end

  get '/tasks' do                           # whare we doing here?
    #@tasks = ["task1", "task2", "task3"]    # well, we create an instance variable @tasks and assign an array of three strings to it.
    @tasks = TaskManager.all
    erb :index                              # then we render the index.erb file. Our instance variable will be available to use in the view.
  end

  get '/tasks/new' do
    erb :new                                # we don't need any instance variables here; we just need to render the view
  end

  post '/tasks' do       # why post instead of get? First, we specified a method of post in our form. Although, we could make it work using get, HTTP convention specifies that a get request should request data from a specified resource while a post should submit data to be processed.
    #"<p>Params: #{params}</p> <p>Task params: #{params[:task]}</p>"
    TaskManager.create(params[:task])
    redirect '/tasks'
  end

  get '/tasks/:id' do |id|
    @task = TaskManager.find(id.to_i)
    erb :show
  end
end
