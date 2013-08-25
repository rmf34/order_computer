require 'rspec'
require 'order_system/merchant'
require 'order_system/order_window'
require 'order_system/order'
require 'order_system/order_computer'

describe "OrderComputer" do
  # could have used many stubs and doubles, but I instead used all of these classes together to serve as integration tests

  let(:merchant) { OrderSystem::Merchant.new }
  let(:ow1) { OrderSystem::OrderWindow.new({start: "23/08/2013 15:00:00", close: "26/08/2013 09:59:59", ship: "27/08/2013 14:00:00"})}
  let(:ow2) { OrderSystem::OrderWindow.new({start: "26/08/2013 10:00:00", close: "27/08/2013 09:59:59", ship: "28/08/2013 14:00:00"})}
  let(:ow3) { OrderSystem::OrderWindow.new({start: "//2013, 8, 27, 10, 0, 0", close: "30/08/2013 14:59:59", ship: "02/09/2013 14:00:00"})}

  let(:order) { OrderSystem::Order.new(merchant)}
  let(:order_computer) { OrderSystem::OrderComputer.new(merchant, order)}

  before(:each) do
    merchant.add_order_window(ow1)
    merchant.add_order_window(ow2)
    merchant.add_order_window(ow3)
  end


  describe "#next_order_deadline" do
    context "between 3pm  fri and 10am mon" do
      let(:order_deadline) {Time.new(2013, 8, 26, 9, 59, 59)}

      it "works for start of range" do
        order.order_time = Time.new(2013, 8, 23, 15, 0, 0)
        order_computer.next_order_deadline.should eq order_deadline
      end

      it "works for end of range" do
        order.order_time = Time.new(2013, 8, 26, 9, 59, 58)
        order_computer.next_order_deadline.should eq order_deadline
      end
    end

    context "between 10am mon and 10am tue" do
      let(:order_deadline) {Time.new(2013, 8, 27, 9, 59, 59)}

      it "works for start of range" do
        order.order_time = Time.new(2013, 8, 26, 10, 0, 0)
        order_computer.next_order_deadline.should eq order_deadline
      end

      it "works for end of range" do
        order.order_time = Time.new(2013, 8, 27, 9, 59, 59)
        order_computer.next_order_deadline.should eq order_deadline
      end
    end

    context "between 10am tue and  3pm fri" do
      let(:order_deadline) {Time.new(2013, 8, 30, 14, 59, 59)}

      it "works for start of range" do
        order.order_time = Time.new(2013, 8, 27, 10, 0, 0)
        order_computer.next_order_deadline.should eq order_deadline
      end

      it "works for end of range" do
        order.order_time = Time.new(2013, 8, 30, 14, 59, 59)
        order_computer.next_order_deadline.should eq order_deadline
      end
    end

    context "a random date in september" do
      let(:order_deadline) {Time.new(2013, 9, 23, 9, 59, 59)}

      it "works" do
        order.order_time = Time.new(2013, 9, 22, 10, 0, 0)
        order_computer.next_order_deadline.should eq order_deadline
      end
    end

  end


  describe "#will_ship_on" do
    context "between 3pm  fri and 10am mon" do
      let(:will_ship) {Time.new(2013, 8, 27, 14, 0, 0)}

      it "works for start of range" do
        order.order_time = Time.new(2013, 8, 23, 15, 0, 0)
        order_computer.will_ship_on.should eq will_ship
      end

      it "works for end of range" do
        order.order_time = Time.new(2013, 8, 26, 9, 59, 58)
        order_computer.will_ship_on.should eq will_ship
      end
    end

    context "between 10am mon and 10am tue" do
      let(:will_ship) {Time.new(2013, 8, 28, 14, 0, 0)}

      it "works for start of range" do
        order.order_time = Time.new(2013, 8, 26, 10, 0, 0)
        order_computer.will_ship_on.should eq will_ship
      end

      it "works for end of range" do
        order.order_time = Time.new(2013, 8, 27, 9, 59, 59)
        order_computer.will_ship_on.should eq will_ship
      end
    end

    context "between 10am tue and  3pm fri" do
      let(:will_ship) {Time.new(2013, 9, 2, 14, 0, 0)}

      it "works for start of range" do
        order.order_time = Time.new(2013, 8, 27, 10, 0, 0)
        order_computer.will_ship_on.should eq will_ship
      end

      it "works for end of range" do
        order.order_time = Time.new(2013, 8, 30, 14, 59, 59)
        order_computer.will_ship_on.should eq will_ship
      end
    end
  end


  describe "#start_time" do
    it "sets a base date" do
      order_computer.start_time.should eq Time.parse("23/08/2013 15:00:00").to_i
    end
  end

  describe "#relative_next_order_deadline" do
    it "adds timezone offset" do
      order_computer.relative_next_order_deadline.should eq (order_computer.next_order_deadline + order_computer.send(:timezone_offset))
    end
  end

  describe "#relative_order_ship_time" do
    it "adds timezone offset" do
      order_computer.relative_order_ship_time.should eq (order_computer.will_ship_on + order_computer.send(:timezone_offset))
    end
  end


end