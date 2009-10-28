class Publisher < ActiveRecord::Base
  
  validates_length_of :name, :in => 2..255
  validates_uniqueness_of :name
  
end
