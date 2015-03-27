class Task
  attr_reader :title,
              :description,
              :id

  def initialize(data)                    # upon initialization it accepts a data hash and access each piece of data via the keys
    @id           = data["id"]
    @title        = data["title"]
    @description  = data["description"]
  end
end
