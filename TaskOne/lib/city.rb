class City < Entity
  attr_reader :name, :shop, :inn, :fight_area_nr, :fight_area
  def parse(data)
    @name = data[:name]
    @shop = data[:shop]
    @inn = data[:inn]
    @fight_area_nr = data[:fight_area_nr]
    @fight_area = data[:fight_area]
    puts @fight_area[1]
  end
end