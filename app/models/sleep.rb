class Sleep < ActiveRecord::Base
  QUALITY = {"Serene" => 5, "Okay" => 3, "Abysmal" => 1, "Restless" => 2, "Restful" => 4, " "=>" "}
  QUALITY_BACKWARDS = {5 => "Serene", 3 => "Okay", 1 => "Abysmal", 2 => "Restless", 4 => "Restful", " "=>" "}
  belongs_to :user
  
	validate :not_a_time_traveller?
	validate :sleep_is_reasonable?
	validate :no_overlap?

	private
	def not_a_time_traveller?
	  if stop < start
	    errors.add(:start, "Stop time must not be before start time.")
	    errors.add(:stop, "Stop time must not be before start time.")
    end
  end
	
	def sleep_is_reasonable?
	  if (stop - start) > 86400.to_f
	    errors.add(:start, "One sleep event can't be more than 24 hours past start time. If you really slept that long add more events.")
	    errors.add(:stop, "One sleep event can't be more than 24 hours past start time. If you really slept that long add more events.")
    end
  end
  
  def no_overlap?
    @sleeps = Sleep.find(:all, :conditions => ["user_id=?", user_id])
    for sleep in @sleeps
      unless start > sleep.stop || stop < sleep.start || sleep.id = id
        errors.add(:id, "Sleep events cannot overlap, one of your sleeps overlaps with this entry.<br />
        According to your yawnlog you were already sleeping from #{sleep.start.strftime("%a, %m/%d/%y %I:%M%p")} to #{sleep.stop.strftime("%a, %m/%d/%y %I:%M%p")} so you probably weren't also sleeping from #{start.strftime("%a, %m/%d/%y %I:%M%p")} to #{stop.strftime("%a, %m/%d/%y %I:%M%p")}")
      end
    end
  end
end
