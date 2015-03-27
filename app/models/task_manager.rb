require 'yaml/store'              # this allows us to store data in a specific file using YAML format, which is part of the Ruby standard library
require_relative 'task'

class TaskManager
  def self.database          # this class method will return an instance of our YAML::Store using the "db/task_manager" file.
    @database ||= YAML::Store.new("db/task_manager") #This file will be created if it does not already exit.
  end

  def self.create(task)           # this class method will accept a task hash (params[:task].
    database.transaction do       # we call the transaction method on our database, which allows us to execute several pieces of code together
      database['tasks'] ||= []    # inside of this transaction we try to find ['tasks']. If it doesn't exist we make it an empty array.
      database['total'] ||= 0     # we also want to keep track of a total number of tasks, so we either find that ( database['total'] or assign it to 0
      database['total'] += 1      # next we increase that toal by 1 because we are creating a new task
      database['tasks'] << { "id" => database['total'], "title" => task[:title], "description" => task[:description] }
                                  # finally we take our database['tasks'] and shovel in a hash that includes an id key with a value of the total number of tasks, a title key with a value task[:title], and a description key with a value of task[:description]
# the description input submission is not showing up in the taskmanager file under the db folder
    end
  end

  def self.raw_tasks              # this will go into our YAML file and retrieve everything under database['tasks'].
    database.transaction do
      database['tasks'] || []
    end
  end

#  it would return an array of hashes, one hash for each task in our YAML file. This is ok but what we really want is for these hashes to be actual Task objects
#  that array of hashes would look like: [{"id"=> 1, "title"=>"Make cookies", "description"=>"They are delicious."}, {"id"=>2, "title""=>"Write code.", "description"=>"Always write code."}]

  def self.all
    raw_tasks.map { |data| Task.new (data) }    # the maps over the raw_tasks and pass that data hash into a Task.new.
  end

  def self.raw_task(id)                         # we're take the raw_tasks and finding one where the task["id"] is the same as the id that is passed in
    raw_tasks.find { |task| task["id"] == id }  # That will return a hash of the task data
  end

  def self.find(id)                             # we'll create a Task object from that hash of task data
    Task.new(raw_task(id))
  end
end
