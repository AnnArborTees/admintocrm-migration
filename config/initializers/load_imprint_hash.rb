require 'csv'

years = ["2011", "2012", "2013", "2014", "2015"]
hash_file = File.open('config/imprint_hash.yml', 'w')
different_format = false #3 spreadsheets have first col of order id

years.each do |y|
  year = Rails.root.join("Imprintables Not Found/UnMappableImprints#{y}.csv")

  if y == "2014" || y == "2015"
    different_format = true
  end

  CSV.foreach(year) do |row|

    if different_format
      if row[1].nil? ||row[1].include?("Order ID")
        next
      end

      if row[5].blank? || row[5].downcase.include?("blank") || row[5].include?("/")
        next
      else
        hash_file.puts "#{row[2]}: '#{row[5]}'"
      end
    else
      if row[0].nil? || row[0].include?("Order ID")
        next
      end

      if row[4].blank? || row[4].downcase.include?("blank") || row[4].include?("/")
        next
      else
        hash_file.puts "#{row[1]}: '#{row[4]}'"
      end
    end#end if for determining how to read csv

  end#end CSV loop
end#end years loop
hash_file.close
IMPRINT_HASH = YAML.load_file([Rails.root, 'config', 'imprint_hash.yml'].join("/"))
