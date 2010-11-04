
class Entity
  attr_accessor :name
  def initialize(path)
    data = YamlManage.load_file(path)
    parse(data)
  end
  
  def parse(data)
    @name = data[:name]
  end
end