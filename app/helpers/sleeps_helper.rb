require 'google_chart'

module SleepsHelper
  def time_intersection(start1, stop1, start2, stop2)
    if start1 < start2
      early_start = start1
      early_stop = stop1
      late_start = start2
      late_stop = stop2
    else
      early_start = start2
      early_stop = stop2
      late_start = start1
      late_stop = stop1
    end
    if early_stop <= late_start
      d = 0
    elsif early_stop < late_stop
      d = early_stop - late_start
    else 
      d = late_stop - late_start
    end
    return d
  end
  
  def calculate_sleep_on_date(date,user_id)
    end_of_day = 24 # use 24 instead of 0
    day_start = DateTime.new(y=date.year,m=date.month,d=date.day-1,h=end_of_day,min=0,s=0)
    day_stop = DateTime.new(y=date.year,m=date.month,d=date.day,h=end_of_day,min=0,s=0)
    
    # should filter sleep.stop isn't < day.start, sleep.start isn't > day.stop    
    @sleeps = Sleep.find(:all, :conditions => ["user_id=? AND start<? AND stop>?",user_id, day_stop, day_start])
    
    duration = 0
    for @sleep in @sleeps
      sleep_start = DateTime.new(y=@sleep.start.year, m=@sleep.start.month, d=@sleep.start.day, 
                                 h=@sleep.start.hour, min=@sleep.start.min, s=@sleep.start.sec)
      sleep_stop = DateTime.new(y=@sleep.stop.year, m=@sleep.stop.month, d=@sleep.stop.day, 
                                h=@sleep.stop.hour, min=@sleep.stop.min, s=@sleep.stop.sec)
      duration += time_intersection(day_start, day_stop, sleep_start, sleep_stop)
    end
    return duration
  end
  
  def calculate_sleep_range(start_date,end_date,user_id)
    #iterates over each in the range and builds a hash table with the amount of sleep on each day.
    if start_date > end_date #you broke the contract.
      temp = start_date
      start_date = end_date
      end_date = temp
    end
    
    sleep_bucket = {}
    current_date = start_date
    while current_date <= end_date
      sleep_bucket[current_date] = calculate_sleep_on_date(current_date, user_id)
      current_date += 1.days
    end
    return sleep_bucket
  end  
  
  def range_table(sleep_bucket)
    arrays = sleep_bucket.sort
    return_html = "<table class='csssucks' cellspacing='0'>"
    return_html += "<tr><th>Date</th><th>Hours Slept</th></tr>"

    for array in arrays
      return_html += "<tr><td>" + array[0].to_s + "</td><td>" + (array[1].to_f*24).to_s + "</td></tr>"
    end
    return_html += "</table>"

    return return_html
  end
  
  def sleep_chart_url(start_date,end_date,user_id)
    @user = User.find(user_id)
    sleep_bucket = calculate_sleep_range(start_date,end_date,user_id)
    sleep_array = sleep_bucket.sort #orders bucket by date lowest to highest and returns as ARRAY of ARRAYs
   
   day_array = Array.new()
   hour_array = Array.new()
   target_array = Array.new()
   for sleep in sleep_array
     day_array.push(sleep[0])
     hour_array.push(sleep[1].to_f * 24)
     target_array.push(default_target_hours(@user))
   end
   
   if day_array.length > 9
     day_array = [day_array.first, day_array.last]
   end
   day_array = day_array.map {|x| x.strftime("%m/%d")}
   
   min_hour = hour_array.min
   max_hour = [hour_array.max, target_array.max].max
   
    # Line Chart
    GoogleChart::LineChart.new('600x300', "Sleep-o-Meter", false) do |lc|
      lc.data "Hours Slept", hour_array, '0000ff'
      lc.show_legend = false
      lc.data "Target Hours", target_array, 'ff0000'
      lc.axis :y, :range => [min_hour,max_hour], :color => '000000', :font_size => 16, :alignment => :center
      lc.axis :x, :labels => day_array, :color => '000000', :font_size => 16, :alignment => :center
      lc.grid :x_step => 100.0/(hour_array.length - 1), :y_step => 100.0/(max_hour - min_hour), :length_segment => 1, :length_blank => 0
      return lc.to_url
    end
  end

  #aggregate stuff
  
  def sleep_chart_url_aggregate(start_date,end_date)
    @users = User.find(:all)
    @users.each do |user|
      sleep_bucket = calculate_sleep_range(start_date,end_date,user_id)
      sleep_array = sleep_bucket.sort #orders bucket by date lowest to highest and returns as ARRAY of ARRAYs
   end
   day_array = Array.new()
   hour_array = Array.new()
   target_array = Array.new()
   for sleep in sleep_array
     day_array.push(sleep[0])
     hour_array.push(sleep[1].to_f * 24)
     target_array.push(default_target_hours(@user))
   end
   
   if day_array.length > 9
     day_array = [day_array.first, day_array.last]
   end
   day_array = day_array.map {|x| x.strftime("%m/%d")}
   
   min_hour = hour_array.min
   max_hour = [hour_array.max, target_array.max].max
   
    # Line Chart
    GoogleChart::LineChart.new('600x300', "Sleep-o-Meter", false) do |lc|
      lc.data "Hours Slept", hour_array, '0000ff'
      lc.show_legend = false
      lc.data "Target Hours", target_array, 'ff0000'
      lc.axis :y, :range => [min_hour,max_hour], :color => '000000', :font_size => 16, :alignment => :center
      lc.axis :x, :labels => day_array, :color => '000000', :font_size => 16, :alignment => :center
      lc.grid :x_step => 100.0/(hour_array.length - 1), :y_step => 100.0/(max_hour - min_hour), :length_segment => 1, :length_blank => 0
      return lc.to_url
    end
  end
  
  def average_sleep_on_date(date)
    @users = User.find(:all)
    sleep, count = 0,0
    @users.each do |user|
      usersleep = calculate_sleep_on_date(date,user)*24
      sleep += usersleep
      count += usersleep > 0 ? 1 : 0
    end
    return sleep/count.to_f
  end
  
end
