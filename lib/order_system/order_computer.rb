require_relative 'empty_order_window_error'

module OrderSystem
  class OrderComputer
    attr_accessor :merchant, :order
    attr_writer :offset, :start_time

    def initialize(merchant, order)
      self.merchant = merchant
      self.order = order
      self.offset = offset
      self.start_time = start_time()
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

    def relative_next_order_deadline
      next_order_deadline + timezone_offset
    end

    def relative_order_ship_time
      will_ship_on + timezone_offset
    end


    private

    def week_adjustment
      week_adjustment ||= offset[0] * seconds_in_week
    end

    def seconds_in_week
      3600 * 168
    end

    def timezone_offset
      (order.time_zone - merchant.time_zone) * 3600
    end

    def find_order_range(offset)
      ranges = order_windows_to_ranges
      return_time(ranges)
    end

    def find_ship_time(offset)
      ranges = order_windows_to_ranges(true)
      return_time(ranges)
    end

    def offset
      offset ||= (order.order_time.to_i - start_time).divmod(seconds_in_week)
    end

    def return_time(ranges)
      ranges.each do |range|
        if range[0] === offset[1]
          return range[1] + week_adjustment
        end
      end
    end

    def order_windows_to_ranges(ship = false)
      ranges = Array.new(merchant.order_windows.length) {Array.new(2)}

      unless merchant.order_windows.empty?
        merchant.order_windows.each_with_index do |window, index|
          ranges[index][0] = ((window.start.to_i - start_time)..(window.close.to_i - start_time))
          if ship
            ranges[index][1] = window.ship
          else
            ranges[index][1] = window.close
          end
        end
        return ranges
      else
        raise EmptyOrderWindowError, "You need to add order_windows"
      end
    end

  end
end