class Entity
  attr_accessor :name
  def initialize(path)
    data = YamlManage.load_file(path)
    parse(data)
  end
  
  def parse(data)
    data.each{|k,v| instance_variable_set(:"@#{k}", v)}
  end
end