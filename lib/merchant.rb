class Merchant
  attr_accessor :order_windows, :time_zone, :name

  def initialize(time_zone = -6, name = "Merchant")
    self.order_windows = []
    self.time_zone = time_zone
    self.name = name
  end

  def add_order_window(order_window)
    order_windows << order_window
  end

end