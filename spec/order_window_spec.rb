require 'rspec'
require 'time'
require_relative '../lib/order_window'

describe "OrderWindow" do
  let(:ow1) { OrderWindow.new({
    start: "23/08/2013 15:00:00",
    close: "26/08/2013 09:59:59",
    ship: "27/08/2013 14:00:00"})
            }

  describe "#initialize" do
    it "correctly sets the start time" do
      ow1.start.should eq Time.parse("23/08/2013 15:00:00")
    end

    it "correctly sets the close time" do
      ow1.close.should eq Time.parse("26/08/2013 09:59:59")
    end

    it "correctly sets the ship time" do
      ow1.ship.should eq Time.parse("27/08/2013 14:00:00")
    end
  end

end