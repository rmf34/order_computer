Imagine a pie maker located in Michigan (Central time zone).  Every pie is made to order.  This means there's a delay between when you place your order and when it goes in the mail.  The pie maker only ships three days a week.

Orders placed before 10 am Monday ship on Tuesday at 2pm.
Orders placed before 10 am Tuesday will ship on Wednesday at 2pm
Orders placed before  3 pm Friday will ship on the following Monday at 10am.

Write a program such that:

Given a current date and time in a given time zone, it tells me the Merchant's next order cutoff time, as well as when my pie will ship.

Please write your implementation in Ruby and include some unit tests.

Assertions might look like this:

Time.stub(:now) { Time.new(2013, 8, 20, 10, 0, 0, '-08:00') }
<instance_name>.next_order_deadline.should == Time.new(2013, 8, 23, 12, 0, 0, '-08:00')
<instance_name>.will_ship_on.should eql Date.new(2013, 8, 26 )




Fri      Sat     Sun      Mon      Tues     Wed     Thur      

|3pm----------------------10am     *2pm
                          10am-----10am     *2pm
                                   10am-----------------
--3pm                     *2pm

        10am |---| 10am -ship>2pm

3 ranges
if ordered between 3pm  fri and 10am mon, ship tue 2pm
if ordered between 10am mon and 10am tue, ship wed 2pm
if ordered between 10am tue and  3pm fri, ship mon 2pm


# if ordered between 3pm  fri and 10am mon, ship tue 2pm
start = Time.new(2013, 8, 23, 15, 0, 0, '-06:00')
close = Time.new(2013, 8, 26, 9, 59, 59, '-06:00')
will_ship = Time.new(2013, 8, 27, 14, 0, 0, '-06:00')


# if ordered between 10am mon and 10am tue, ship wed 2pm
start = Time.new(2013, 8, 26, 10, 0, 0, '-06:00')
close = Time.new(2013, 8, 27, 9, 59, 59, '-06:00')
will_ship = Time.new(2013, 8, 28, 14, 0, 0, '-06:00')

# if ordered between 10am tue and  3pm fri, ship mon 2pm
start = Time.new(2013, 8, 27, 10, 0, 0, '-06:00')
close = Time.new(2013, 8, 30, 14, 59, 59, '-06:00')
will_ship = Time.new(2013, 9, 2, 14, 0, 0, '-06:00')


deadlines:
d1 = Time.new(2013, 8, 26, 9, 59, 59, '-06:00').to_i
d2 = Time.new(2013, 8, 27, 9, 59, 59, '-06:00').to_i
d3 = Time.new(2013, 8, 30, 14, 59, 59, '-06:00').to_i



TODO:
1) add user time zone offset (need to have next deadline and when pie will ship displayed in user's time zone)
2) make it so one can interact with the program through the command line, gets.chomp....
