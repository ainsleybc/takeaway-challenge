class Basket

  def initialize

    @list = []

  end

  def add(dish, totalprice)
    @list << [dish, totalprice] 
    compile_order
  end

  def total
    sum = 0
    list.each do |item|
      sum += item[1]
    end
    sum
  end

  def summary
    to_return = []
    list.each do |item|
      to_return << "#{list[1].to_s} #{item[0]} = #{list[3]}"
    end
    to_return.join(', ')
  end


  private

  def compile_order
    list.group_by(&:first).map{ |x, y| [x, y.count, y.inject(0){ |sum, i| sum + i.last }] }
  end

  attr_reader :list

end