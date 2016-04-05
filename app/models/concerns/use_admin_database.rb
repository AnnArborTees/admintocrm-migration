require 'active_support/concern'

module UseAdminDatabase
  extend ActiveSupport::Concern

  included do
    establish_connection Rails.configuration.database_configuration[ [Rails.env, "admin"].join('_') ]
  end

end