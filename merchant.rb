class Merchant
  attr_accessor :order_time, :order_windows, :time_zone
  attr_writer :offset, :start_time

  def initialize(order_time = Time.now, time_zone = -6)
    self.order_time = order_time
    self.start_time = start_time
    self.offset = offset
    self.order_windows = []
    self.time_zone = time_zone
  end

  def next_order_deadline
    find_order_range(offset)
  end

  def will_ship_on
    find_ship_time(offset)
  end

  def start_time
    start_time ||= Time.parse("23/08/2013 15:00:00").to_i
  end

  def add_order_window(ordering_window)
    order_windows << ordering_window
  end


  private

  def seconds_in_week
    3600 * 168
  end

  def week_adjustment
    week_adjustment ||= offset[0] * seconds_in_week
  end

  def find_order_range(offset)
    ranges = order_windows_to_ranges
    return_time(ranges)
  end

  def offset
    offset ||= (order_time.to_i - start_time).divmod(seconds_in_week)
  end

  def find_ship_time(offset)
    ranges = order_windows_to_ranges(true)
    return_time(ranges)
  end

  def return_time(ranges)
    ranges.each do |range|
      if range[0] === offset[1]
        return range[1] + week_adjustment
      end
    end
  end

  def order_windows_to_ranges(ship = false)
    ranges = Array.new(order_windows.length) {Array.new(2)}

    order_windows.each_with_index do |window, index|
      ranges[index][0] = ((window.start.to_i - start_time)..(window.close.to_i - start_time))
      if ship
        ranges[index][1] = window.ship
      else
        ranges[index][1] = window.close
      end
    end
    return ranges
  end

end