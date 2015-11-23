module ImprintHelper
  
  def determine_digital_type(key, imprint_methods)
    name = self.name.downcase
    desc = self.description.downcase 
    
    if imprint_methods.empty? == false
      return
    end

    if name.include?("front and back") || (name.include?("on back") && name.include?("on front")) || name.include?("f+b")
      imprint_methods << IMPRINT_MAP['dtgfb']
    elsif desc.include?("front and back") || (desc.include?("on back") && desc.include?("on front")) || desc.include?("f+b")
      imprint_methods << IMPRINT_MAP['dtgfb']
    elsif name.include?("on back") || desc.include?("on back")
      imprint_methods << IMPRINT_MAP['dtgb']
    else
      imprint_methods << IMPRINT_MAP['dtg']
    end
  end

  def determine_DTG_variant(key, imprint_methods)
    #if key isn't dtg, as in 381/782/541 send it here
    #then it changes key to dtg, as there is a dtg
    #associated with the original key that sent it here
    if key != 'dtg'
      key = 'dtg'
    end

    name = self.name.downcase
    desc = self.description.downcase
    
    num_782 = name.scan('782').size + desc.scan('782').size
    num_381 = name.scan('381').size + desc.scan('381').size
    num_541 = name.scan('541').size + desc.scan('541').size

    #all possible matches of dtg
    #if 782, 381 or 541 has been found, it runs through this statement
    if(num_782 > 0 || num_381 > 0 || num_541 > 0)  
      if num_782 > 0
        if name.include?("782 front and back") || name.include?("782 f/b") || name.include?("f+b 782") || name.include?("front and back")
          imprint_methods << IMPRINT_MAP[key + "wfb"]
        elsif desc.include?("782 front and back") || desc.include?("782 f/b") || desc.include?("f+b 782") || desc.include?("front and back")
          imprint_methods << IMPRINT_MAP[key + "wfb"]
        else
          imprint_methods << IMPRINT_MAP[key + 'w']
        end
      end

      if num_381 > 0
        if(name.include?("381 f/b") || name.include?("381 fr/bk") || name.include?("381 fr/back") || name.include?("381f, 381b"))
          imprint_methods << IMPRINT_MAP[key + 'wfb']
        elsif (name.include?("381 f/b") || desc.include?("381 fr/bk") || desc.include?("381 fr/back") || desc.include?("381f, 381b"))
          imprint_methods << IMPRINT_MAP[key +'wfb']
        elsif name.include?("381nw") || desc.include?("381nw")
          imprint_methods << IMPRINT_MAP[key]
        elsif name.include?("381 b") || desc.include?("381 b")
          imprint_methods << IMPRINT_MAP[key + "wb"]
        else
          imprint_methods << IMPRINT_MAP[key + "w"] 
        end
      end
    
      if num_541 > 0
        if(name.include?("541 f/b") || name.include?("541 f+b") || name.include?("541 front and back") || (name.include?("front") && name.include?("back")) || name.include?("f+b"))
          imprint_methods << IMPRINT_MAP[key + "fb"]
        elsif (desc.include?("541 f/b") || desc.include?("541 f+b") || desc.include?("541 front and back") || desc.include?("f+b") || (desc.include?("541 print on front") && desc.include?("back")))
          imprint_methods << IMPRINT_MAP[key + "fb"]
        elsif name.include?("back") || desc.include?("back")
          imprint_methods << IMPRINT_MAP[key + "b"]
        else
          imprint_methods << IMPRINT_MAP[key]
        end
      end

    else
      if name.include?(key + "wfb")
        imprint_methods << IMPRINT_MAP[key + "wfb"]
      elsif (name.include?(key + "wb"))
        imprint_methods << IMPRINT_MAP[key + "wb"]
      elsif (name.include?(key+"w") || name.include?(key+"wf"))
        imprint_methods << IMPRINT_MAP[key + "w"]

      elsif(name.include?("fr/ bk") || name.include?("fr. bk") || name.include?("fr/bk") || name.include?("all over") || name.include?("dtg fr/dtg-bk") || name.include?("f+b") || name.include?("dtgf/dtgb"))
         imprint_methods << IMPRINT_MAP[key + "fb"]
      elsif name.include?("_back")
        imprint_methods << IMPRINT_MAP[key + "b"]
      else
        imprint_methods << IMPRINT_MAP[key]
      end
    end
  end

  def determine_color_location(key, val, imprint_methods)
    name = self.name.downcase
    num_keyB = name.scan(key+'b').size
    num_keyS = name.scan(key+'s').size
    num_keyF = name.scan(key+'f').size
    num_keyRS = name.scan(key+'rs').size
    num_keyLS = name.scan(key+'ls').size
    num_key = name.scan(key).size#straight #c or straight #s

    num_total_keys = num_keyB + num_keyS + num_keyRS + num_keyLS + num_keyF
    
    if(num_total_keys > num_key) && num_keyF_found == 0
      imprint_methods << val
    elsif (num_key > num_total_keys)
      imprint_methods << val
    else
      return
    end
  end
end
