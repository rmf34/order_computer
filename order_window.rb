class OrderWindow
  attr_accessor :start, :close, :ship

  def initialize(args)
    self.start = set_attr(args, :start)
    self.close = set_attr(args, :close)
    self.ship  = set_attr(args, :ship)
  end


  private

  def set_attr(args, key)
    Time.parse(args.fetch(key))
  end

end
