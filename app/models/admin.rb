module Admin

  def self.table_name_prefix
    Rails.env.test? ? 'admin_' : ''
  end

  def self.database_name
    Rails.configuration.database_configuration[ [Rails.env, "admin"].join('_') ]
  end

end
