require 'active_support/concern'

module UseAdminDatabase
  extend ActiveSupport::Concern

  included do
    establish_connection configurations['mysql'][ [Rails.env, "_admin"].join('_') ]
  end

end