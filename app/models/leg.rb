class Leg < ActiveRecord::Base
  belongs_to :route
  has_many :steps
end
