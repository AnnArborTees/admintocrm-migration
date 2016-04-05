class PrintLocation < ActiveRecord::Base
  belongs_to :imprint_method
  has_many :imprints

end
