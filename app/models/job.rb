class Job < ActiveRecord::Base
  belongs_to :order, foreign_key: :jobbable_id
  has_many :line_items, as: :line_itemable, foreign_key: :line_itemable_id
  has_many :imprints, foreign_key: :job_id

  validates :order, presence: true
  validates :name, presence: true
  validates :description, presence: true

  include ImprintMethodHelper

  def self.new_job_from_admin_job(admin_job)
    if admin_job.title.blank?
      return nil
    end

    job = self.find_or_initialize_by(
      name: admin_job.title,
      description: admin_job.description,
    )

    job.jobbable_id = admin_job.custom_order_id
    jobbable_type = admin_job.type
    return job
  end

  def self.find_or_create_from_admin_job(order, aj)
    if aj.nil? || aj.title.blank?
      return nil
    end

    if aj.description.nil? || aj.description.blank?
      aj.description = "No description from Admin Job"
    end

    job = self.find_or_create_by(
      name: aj.title,
      description: aj.description
    )
    job.jobbable_id = order.id
    job.jobbable_type = "Order"
    job.collapsed = false
    job.save
    return job
  end

  def determine_imprint_methods(admin_job, unmappable)
    imprint_methods = []
    IMPRINT_MAP.each do |key, val|
      if self.name.downcase.include?(key) || self.description.downcase.include?(key)
        #key is #c/#s and will prevent overlap between front/back/sleeve
        if key.last == 'c' || key.last == 's'
          self.determine_color_location(key, imprint_methods)
          next
        end

        #skips dtgw/wf/etc and waits for dtg key to prevent overlap
        next if (key.include?("dtg") && key != "dtg")

        if key == "emb" #special emb case where they don't want embroidery
          next if self.name.downcase.include?("no emb") || self.description.downcase.include?("no emb")
        end

        #all other filtering cases
        case key
        when "dtg","381","782","541"
          self.determine_dtg_variant(key, imprint_methods)
        when "digital"
          self.determine_digital_type(key, imprint_methods)
        else
          imprint_methods << val
        end
      end
    end

    if imprint_methods.empty?
      key = admin_job.title.gsub("\n", "")
      imprint_description = unmappable[key]
      puts admin_job.title if imprint_description.blank?
      return ["#{admin_job.title}"] if imprint_description.blank?
      imprint_strings = imprint_description.gsub(", ", ",").split(",")
      imprint_strings.each{|x| imprint_methods << IMPRINT_MAP[x] unless IMPRINT_MAP[x].blank? }
    end

    return imprint_methods.uniq
  end
end
