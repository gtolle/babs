class Step < ActiveRecord::Base
  belongs_to :route
  belongs_to :leg
end
