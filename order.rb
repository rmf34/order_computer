class Order

  attr_accessor :order_time, :merchant, :time_zone

  def initialize(merchant, time_zone = -6, order_time = Time.now)
    self.merchant = merchant
    self.time_zone = time_zone
    self.order_time = order_time
  end

  def relative_next_order_deadline
    merchant.next_order_deadline + timezone_offset
  end

  def relative_order_ship_time
    merchant.will_ship_on + timezone_offset
  end


  private

  def timezone_offset
    (time_zone - merchant.time_zone) * 3600
  end

end