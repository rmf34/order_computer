require 'time'
require_relative 'lib/order_system/order_window'
require_relative 'lib/order_system/merchant'
require_relative 'lib/order_system/order'
require_relative 'lib/order_system/order_computer'

def process_order(time_zone)
  ow1 = OrderSystem::OrderWindow.new({start: "23/08/2013 15:00:00", close: "26/08/2013 09:59:59", ship: "27/08/2013 14:00:00"})
  ow2 = OrderSystem::OrderWindow.new({start: "26/08/2013 10:00:00", close: "27/08/2013 09:59:59", ship: "28/08/2013 14:00:00"})
  ow3 = OrderSystem::OrderWindow.new({start: "27/08/2013 10:00:00", close: "30/08/2013 14:59:59", ship: "02/09/2013 14:00:00"})

  pie_store = OrderSystem::Merchant.new
  pie_store.add_order_window(ow1)
  pie_store.add_order_window(ow2)
  pie_store.add_order_window(ow3)
  raspberry_pie = OrderSystem::Order.new(pie_store, time_zone)
  order_computer = OrderSystem::OrderComputer.new(pie_store, raspberry_pie)


  date_format = "%A %b %e, %I:%M %P"
  puts "Your order will ship: #{order_computer.relative_order_ship_time.strftime(date_format)}"
  puts "The next order deadline: #{order_computer.relative_next_order_deadline.strftime(date_format)}"
  puts
end

def run_program
  loop do
    prompt = "> "
    puts "Any character to place an order, 'quit' to exit"
    print prompt
    answer = gets.chomp.downcase
    if answer == "quit" || answer == "exit" || answer == "q" || answer == "x"
      puts "thank you for using our system"
      break
    else
      options = ["enter a letter pick your time zone", "a) Eastern time", "b) Central time", "c) Mountain time", "d) Pacific time"]
      options.each { |option| puts option }
      print prompt
      user_input = gets.chomp.downcase
      zones = {"a" => [-4, "Eastern"], "b" => [-5, "Central"], "c" => [-6, "Mountain"], "d" => [-7, "Pacific"]}
      if user_input.match(/^[a-d]/) && user_input.length == 1
        time_zone = zones[user_input][0]
        puts; puts "Times are adjusted to your time zone"
        puts "you selected: #{zones[user_input][1]} time (#{time_zone}:00)"; puts
        process_order(time_zone)
      else
        puts "We're sorry that input was not recognized, please try again."
        run_program
      end
    end
  end
end


puts; puts "Welcome to the ordering system"; puts
run_program()



