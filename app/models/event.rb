class Event < ActiveRecord::Base
validates :summary, :description, :location, :attendees, presence: true
end
