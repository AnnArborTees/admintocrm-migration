class ImprintMethod < ActiveRecord::Base
  has_many :print_locations, dependent: :destroy
end
