require 'time'
require_relative 'order_window'
require_relative 'merchant'
require_relative 'order'


ow1 = OrderWindow.new({start: "23/08/2013 15:00:00", close: "26/08/2013 09:59:59", ship: "27/08/2013 14:00:00"})
ow2 = OrderWindow.new({start: "26/08/2013 10:00:00", close: "27/08/2013 09:59:59", ship: "28/08/2013 14:00:00"})
ow3 = OrderWindow.new({start: "27/08/2013 10:00:00", close: "30/08/2013 14:59:59", ship: "02/09/2013 14:00:00"})


pie_store = Merchant.new
pie_store.add_order_window(ow1)
pie_store.add_order_window(ow2)
pie_store.add_order_window(ow3)


puts; puts "Welcome to the ordering system"; puts

time_zone = nil
while time_zone.nil?
  puts "enter a letter pick your time zone"
  puts "a) Eastern time"
  puts "b) Central time"
  puts "c) Mountain time"
  puts "d) Pacific time"
  print "> "
  user_input = gets.chomp.downcase[0]
  zones = {"a" => [-4, "Eastern"], "b" => [-5, "Central"], "c" => [-6, "Mountain"], "d" => [-7, "Pacific"]}
  time_zone = zones[user_input][0]

  puts "you selected: #{zones[user_input][1]} time (#{time_zone}:00)"
end


raspberry = Order.new(pie_store, time_zone)


date_format = "%A %b %e, %I:%M %P"
p "will ship: #{raspberry.relative_next_order_deadline.strftime(date_format)}"
p "next order deadline: #{raspberry.relative_order_ship_time.strftime(date_format)}"


