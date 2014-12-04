class DataManipulation

  attr_reader :data, :average

  def initialize data, average
    @data = data
    @average = average
  end

  def show_all
    puts table_format(data)
  end

  def show_filtered
    filter_data.each do |key, employees|
      puts "\t\t\t #{key.color(:red)} "
      puts table_format(employees)
    end
  end

  private

  def filter_data
    data.select{ |employer| employer["salary"]  > average }
            .sort_by{ |employer| employer["lastName"] }
            .group_by{ |employer| employer["department"] }
  end

  def table_format data
    Terminal::Table.new do |t|
      t.title = "Employees".color(:green)
      t.headings = data.first.keys.map(&:capitalize).map{ |key| key.color(:yellow)}
      t.style = {:width => 60}
      data.each_with_index do |employer, index|
        t << employer.values.map{|data| {value: data, :alignment => :center} }
        t << :separator unless index + 1 == data.length
      end
    end
  end

end