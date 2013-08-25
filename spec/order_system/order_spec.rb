require 'rspec'
require 'time'
require 'order_system/order'

describe "Order" do

  before(:each) do
    @ten_am = Time.parse("25/08/2013 10:00:00")
    Time.stub(:now) { @ten_am }
    @pie_seller = double("Merchant")
    @order = OrderSystem::Order.new(merchant: @pie_seller)
    @order.time_zone = -4 #eastern
  end

  describe "#initialize" do
    it "has the correct merchant" do
      expect{@order.merchant}.to be{@pie_seller}
    end

    it "has the correct time_zone" do
      @order.time_zone.should eq -4
    end

    it "has the correct order time" do
      @order.order_time.should eq Time.now
    end
  end

end