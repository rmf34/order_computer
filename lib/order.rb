class Order
  attr_accessor :merchant, :time_zone, :order_time

  def initialize(merchant, time_zone = -6)
    self.merchant = merchant
    self.time_zone = time_zone
    self.order_time = Time.now
  end

end