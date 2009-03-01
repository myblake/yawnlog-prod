module UsersHelper

  def default_target_hours(user)
    if user.target_hours
      return user.target_hours.to_f
    else
      return 8.to_f
    end
  end

  def sleep_debt_for_date(date, user_id)
    @user = User.find(user_id)
    target_hours = default_target_hours(@user)
    
    sleep = (calculate_sleep_on_date(date,@user.id) * 24).to_f
    delta = target_hours - sleep
    
    return delta
  end
  
  def average_sleep_for_range(start_date, end_date, user_id)
    @user = User.find(user_id)
    @earliest_sleep = Sleep.find(:first, :conditions => ["user_id=?",user_id], :order => "start ASC")
    target_hours = default_target_hours(@user)
    
    if @earliest_sleep == nil #bomb if you have no sleep.
      return 0
    end

    #if you haven't existed long enough, do it for less time.
    earliest_start = Date.new(y=@earliest_sleep.start.year, m=@earliest_sleep.start.month, d=@earliest_sleep.start.day)
    if  earliest_start > start_date
      start_date = earliest_start
    end
    
    if start_date > end_date #you broke the contract.
      temp = start_date
      start_date = end_date
      end_date = temp
    end

    #iterates over each in the range and builds a hash table with the amount of sleep on each day.
    total_sleep_debt = 0
    total_days = 0
    current_date = start_date
    while current_date <= end_date
      total_sleep_debt += calculate_sleep_on_date(current_date, user_id)
      total_days += 1
      current_date += 1.days
    end
    return (total_sleep_debt * 24 / total_days).to_f
  end

  def average_sleep_debt_for_range(start_date, end_date, user_id)
    @user = User.find(user_id)
    target_hours = default_target_hours(@user)
    average = average_sleep_for_range(start_date, end_date, user_id)
    return target_hours - average
  end

  
end
