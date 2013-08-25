require 'rspec'
require_relative '../../lib/order_system/merchant'
require_relative '../../lib/order_system/order_window'


describe "Merchant" do

  let(:merchant) { OrderSystem::Merchant.new }
  let(:ow1) { OrderSystem::OrderWindow.new({start: "23/08/2013 15:00:00", close: "26/08/2013 09:59:59", ship: "27/08/2013 14:00:00"})}
  let(:ow2) { OrderSystem::OrderWindow.new({start: "26/08/2013 10:00:00", close: "27/08/2013 09:59:59", ship: "28/08/2013 14:00:00"})}
  let(:ow3) { OrderSystem::OrderWindow.new({start: "//2013, 8, 27, 10, 0, 0", close: "30/08/2013 14:59:59", ship: "02/09/2013 14:00:00"})}

  before(:each) do
    merchant.add_order_window(ow1)
    merchant.add_order_window(ow2)
    merchant.add_order_window(ow3)
  end


  describe "#add_order_window" do
    it "increases the merchant's count of order windows" do
      expect{merchant.add_order_window(ow1)}.to change{merchant.order_windows.count}.from(3).to(4)
    end
  end


end