class DataManipulation

  attr_reader :data

  def initialize data
    @data = data
  end

  def show_all
    @data = @data["employees"] if check_xml?
    puts table_format(data)
  end

  def show_entry
    @data = @data["employees"] if check_xml_entry?
    puts entry_table_format(data)
  end

  private

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

  def entry_table_format data
    Terminal::Table.new do |t|
      t.title = "Employeer".color(:green)
      t.headings = data.keys.map(&:capitalize).map{ |key| key.color(:yellow)}
      t.style = {:width => 60}
      t << data.values.map{|data| {value: data, :alignment => :center} }
    end
  end

  def check_xml?
    data.is_a? Hash
  end

  def check_xml_entry?
    data.has_key? "employees"
  end

end