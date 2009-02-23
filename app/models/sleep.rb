class Sleep < ActiveRecord::Base
  QUALITY = {"Serene" => 5, "Okay" => 3, "Abysmal" => 1, "Restless" => 2, "Restful" => 4}
  QUALITY_BACKWARDS = {5 => "Serene", 3 => "Okay", 1 => "Abysmal", 2 => "Restless", 4 => "Restful"}
  belongs_to :user
  
	validate :not_a_time_traveller?
	validate :sleep_is_reasonable?
	validate :no_overlap?

	private
	def not_a_time_traveller?
	  if stop < start
	    errors.add(:stop, "Stop time must not be before start time.")
    end
  end
	
	def sleep_is_reasonable?
	  if (stop - start) > 86400.to_f
	    errors.add("Too long:", "One sleep event can't be more than 24 hours past start time. If you really slept that long add more events.")
    end
  end
  
  def no_overlap?
    @sleeps = Sleep.find(:all, :conditions => ["user_id=?", user_id])
    for sleep in @sleeps
      unless start > sleep.stop || stop < sleep.start || sleep.id = id
        errors.add("Overlap error:", "Sleep events cannot overlap, one of your sleeps overlaps with this entry.")
      end
    end
  end
end
