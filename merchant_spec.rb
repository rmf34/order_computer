require 'rspec'
require_relative 'merchant'
require_relative 'order_window'


describe "Merchant" do

  let(:merchant) { Merchant.new }
  let(:ow1) { OrderWindow.new({start: "23/08/2013 15:00:00", close: "26/08/2013 09:59:59", ship: "27/08/2013 14:00:00"})}
  let(:ow2) { OrderWindow.new({start: "26/08/2013 10:00:00", close: "27/08/2013 09:59:59", ship: "28/08/2013 14:00:00"})}
  let(:ow3) { OrderWindow.new({start: "//2013, 8, 27, 10, 0, 0", close: "30/08/2013 14:59:59", ship: "02/09/2013 14:00:00"})}

  before(:each) do
    merchant.add_order_window(ow1)
    merchant.add_order_window(ow2)
    merchant.add_order_window(ow3)
  end


  describe "#next_order_deadline" do
    context "between 3pm  fri and 10am mon" do
      let(:order_deadline) {Time.new(2013, 8, 26, 9, 59, 59)}

      it "works for start of range" do
        merchant.order_time = Time.new(2013, 8, 23, 15, 0, 0)
        merchant.next_order_deadline.should eq order_deadline
      end

      it "works for end of range" do
        merchant.order_time = Time.new(2013, 8, 26, 9, 59, 58)
        merchant.next_order_deadline.should eq order_deadline
      end
    end

    context "between 10am mon and 10am tue" do
      let(:order_deadline) {Time.new(2013, 8, 27, 9, 59, 59)}

      it "works for start of range" do
        merchant.order_time = Time.new(2013, 8, 26, 10, 0, 0)
        merchant.next_order_deadline.should eq order_deadline
      end

      it "works for end of range" do
        merchant.order_time = Time.new(2013, 8, 27, 9, 59, 59)
        merchant.next_order_deadline.should eq order_deadline
      end
    end

    context "between 10am tue and  3pm fri" do
      let(:order_deadline) {Time.new(2013, 8, 30, 14, 59, 59)}

      it "works for start of range" do
        merchant.order_time = Time.new(2013, 8, 27, 10, 0, 0)
        merchant.next_order_deadline.should eq order_deadline
      end

      it "works for end of range" do
        merchant.order_time = Time.new(2013, 8, 30, 14, 59, 59)
        merchant.next_order_deadline.should eq order_deadline
      end
    end

    context "a random date in september" do
      let(:order_deadline) {Time.new(2013, 9, 23, 9, 59, 59)}

      it "works" do
        merchant.order_time = Time.new(2013, 9, 22, 10, 0, 0)
        merchant.next_order_deadline.should eq order_deadline
      end
    end

  end


  describe "#will_ship_on" do
    context "between 3pm  fri and 10am mon" do
      let(:will_ship) {Time.new(2013, 8, 27, 14, 0, 0)}

      it "works for start of range" do
        merchant.order_time = Time.new(2013, 8, 23, 15, 0, 0)
        merchant.will_ship_on.should eq will_ship
      end

      it "works for end of range" do
        merchant.order_time = Time.new(2013, 8, 26, 9, 59, 58)
        merchant.will_ship_on.should eq will_ship
      end
    end

    context "between 10am mon and 10am tue" do
      let(:will_ship) {Time.new(2013, 8, 28, 14, 0, 0)}

      it "works for start of range" do
        merchant.order_time = Time.new(2013, 8, 26, 10, 0, 0)
        merchant.will_ship_on.should eq will_ship
      end

      it "works for end of range" do
        merchant.order_time = Time.new(2013, 8, 27, 9, 59, 59)
        merchant.will_ship_on.should eq will_ship
      end
    end

    context "between 10am tue and  3pm fri" do
      let(:will_ship) {Time.new(2013, 9, 2, 14, 0, 0)}

      it "works for start of range" do
        merchant.order_time = Time.new(2013, 8, 27, 10, 0, 0)
        merchant.will_ship_on.should eq will_ship
      end

      it "works for end of range" do
        merchant.order_time = Time.new(2013, 8, 30, 14, 59, 59)
        merchant.will_ship_on.should eq will_ship
      end
    end
  end

end