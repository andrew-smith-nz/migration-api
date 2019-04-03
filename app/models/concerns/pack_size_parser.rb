module PackSizeParser
  def build_result_from_pack_size pack_size
    result = OpenStruct.new
    result.id = pack_size.id
    result.description =  pack_size.description
    result.pack_size = pack_size.pack_size
    result
  end

  def is_number(string)
    return !string.nil? && string.match(/[0-9]*[.]*[0-9]+/).present?
  end

  def parse_pack_sizes(pack_sizes)
    inputs = pack_sizes.map {|ps| build_result_from_pack_size ps }
    @abbreviations = UnitAbbreviation.all.order(:execution_order)
    inputs.each do |input|
      input.original_pack_size = input.pack_size
      input.pack_size = input.pack_size.downcase
      input.pack_size.gsub!('#10', 'NumberTenCan')  #special handling for #10 Can, which is otherwise a massive pain in the ass due to # also meaning pounds
    end
    inputs.each do |input|
      # work backwards from the end
      input.pack_size = input.pack_size.downcase
      has_numbers = input.pack_size.match(/[0-9]+/).present?
      has_letters = input.pack_size.match(/[^0-9. ]+/).present?
      split = input.pack_size.scan(/[\d]*[.]*[\d]+|[^\d. ]+/)
      split = split.map{|s| s.strip.gsub(/[^0-9a-z .#]/i, '')}.reject { |c| c.empty? }
      # special handling for #/cs notation
      if (split.last == 'cs' || split.last == 'case' || split.last == 'eacs')
        is_case_notation = true
        input.quantity_string = 'cs'
        split.pop
      end

      if (!is_number(split.last))
        input.unit_string = split.last
        split.pop
      else
        input.unit_string = ''
      end
      input.unit_dimension_1 = split.last
      split.pop
      while (split.last == 'x')
        split.pop
        input.unit_dimension_3 = input.unit_dimension_2
        input.unit_dimension_2 = input.unit_dimension_1
        input.unit_dimension_1 = split.last
        split.pop
      end
      if (split.last.nil? || !is_number(split.last))
        if (split.last == 'cs' || is_case_notation)
          input.units_in_pack = 1
        elsif (input.unit_dimension_2.present?)
          input.units_in_pack = input.unit_dimension_1
          input.unit_dimension_1 = input.unit_dimension_2
          input.unit_dimension_2 = input.unit_dimension_3
        end
      end
      while split.last.present?
        if is_number(split.last)
          input.units_in_pack = split.last
        else
          input.quantity_string = split.last || 'Pack'
        end
        split.pop
      end
      input.quantity_string = input.quantity_string || ''
      input.unit_dimension_1 = input.unit_dimension_1 || 1
      input.units_in_pack = input.units_in_pack || 1

      @abbreviations.each do |abbrev|
        if (input.unit_string == abbrev.abbreviation)
          input.unit_string = abbrev.unit
          break
        end
      end
      @abbreviations.each do |abbrev|
        if (input.quantity_string == abbrev.abbreviation)
          input.quantity_string = abbrev.unit
          break
        end
      end
      input.pack_description = (input.quantity_string.present? ? (' ' + input.quantity_string) : '').strip.humanize
      input.unit_string&.gsub!('.', '')
      input.unit_string = 'each' if input.unit_string&.empty? && input.unit_dimension_2.nil?
      input.unit_string = input.unit_string&.humanize || ''
      input.unit_dimension_1 = input.unit_dimension_1&.to_f
      input.unit_dimension_2 = input.unit_dimension_2&.to_f
      input.unit_dimension_3 = input.unit_dimension_3&.to_f
      if (input.unit_string.match(/\(.*\)/).present?)
        input.notes = input.unit_string.match(/\(.*\)/).to_s.gsub(/\(|\)/, '')
        input.unit_string.gsub!(/[ ]*\(.*\)/, '')
      end
      input.valid = !input.units_in_pack.to_s.empty? && !input.unit_dimension_1.to_s.empty? #&& has_numbers && has_letters
    end
    inputs
  end

  # def parse_pack_sizes_old(pack_sizes)
  #   inputs = pack_sizes.map {|ps| build_result_from_pack_size ps }
  #   @abbreviations = UnitAbbreviation.all.order(:execution_order)
  #   inputs.each do |input|
  #     input.original_pack_size = input.pack_size
  #     input.pack_size = input.pack_size.downcase
  #   end
  #   # NotationReplacement.all.order(:execution_order).each do |rep|
  #   #   inputs.each do |input|
  #   #     input["pack_size"].sub!(rep.to_replace, rep.replace_with)
  #   #   end
  #   # end
  #   inputs.each do |input|
  #     puts input["pack_size"].scan(/\d+|\D+/)
  #     split = input["pack_size"].split('|')
  #     quantity_number = split[0]&.match(/[0-9]*[.]*[0-9]*/).to_s
  #     quantity_string = split[0]&.match(/[^0-9 .x]+/).to_s
  #     unit_number = quantity_number
  #     unit_string = quantity_string
  #     if (split[1].present?)
  #       if (split[1] == 'cs' || split[1] == 'case')
  #         unit_number = quantity_number
  #         quantity_number = 1
  #         unit_string = 'case'
  #       elsif (split[1].match(/[0-9]*[x][0-9]*/).present?)
  #         unit_number = nil
  #         unit_string = split[1]
  #       else
  #         unit_number = split[1].match(/[0-9]*[.]*[0-9]*[-]*[0-9]*[.]*[0-9]*/).to_s
  #         unit_string = split[1].sub(unit_number, '').strip
  #       end
  #     else
  #       quantity_number = 1
  #       quantity_string = nil
  #     end
  #     @abbreviations.each do |abbrev|
  #       if (unit_string.include?(abbrev.abbreviation))
  #         unit_string.sub!(abbrev.abbreviation, abbrev.unit)
  #         break
  #       end
  #     end
  #     @abbreviations.each do |abbrev|
  #       if (quantity_string&.include?(abbrev.abbreviation))
  #         quantity_string.sub!(abbrev.abbreviation, abbrev.unit)
  #         break
  #       end
  #     end
  #     if (unit_string.ends_with?('av') || unit_string.ends_with?('avg') || unit_string.ends_with?('*'))
  #       unit_string.sub!(/avg|av|\*/, ' (average)')
  #     end
  #     unit_string = unit_string[0...-1] if unit_string.last == '.'
  #     #unit_string = unit_string if !unit_string.match(/[0-9]*[x][0-9]*/).present?
  #     quantity_number = 1 if quantity_number == ''
  #     unit_number = 1 if unit_number == ''
  #     input.units_in_pack =  quantity_number.to_s
  #     input.pack_description = (quantity_string.present? ? (' ' + quantity_string) : '').strip.humanize
  #     if unit_string.include?('x')
  #       dimensions = unit_string.split('x')
  #       input.unit_dimension_1 = dimensions[0]&.match(/[0-9]*[.]*[0-9]*/)&.to_s
  #       input.unit_dimension_2 = dimensions[1]&.match(/[0-9]*[.]*[0-9]*/)&.to_s
  #       input.unit_dimension_3 = dimensions[2]&.match(/[0-9]*[.]*[0-9]*/)&.to_s
  #       input.unit_string = unit_string.gsub(/[0-9x.]/, '') != "" ? unit_string.gsub(/[0-9x.]/, '').humanize : unit_string.humanize
  #     else
  #       input.unit_dimension_1 = unit_number
  #       input.unit_dimension_2 = nil
  #       input.unit_dimension_3 = nil
  #       input.unit_string = unit_string&.humanize || ''
  #     end
  #     input.valid = unit_string.present? && input.unit_dimension_1.present?
  #   end
  #   inputs
  # end
end