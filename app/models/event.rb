class Event < ActiveRecord::Base
  belongs_to :user
  has_many  :activities, dependent: :destroy
  scope :visible_to, -> (user) { user ? all : where(@events.user = @user) }
  
  geocoded_by :location
  after_validation :geocode
  
  def self.weather(event)
    event.geocode
    lat = event.latitude
    lng = event.longitude
    time = event.startdate.to_time.iso8601
    @weather = ForecastIO.forecast(lat, lng, time: time)
  end
end
