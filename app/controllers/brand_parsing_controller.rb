class BrandParsingController < ApplicationController
  include BrandParser

  def index
    @parsed_brands = find_matches
    render
  end

  def search
    @parsed_brands = find_matches
    render "index"
  end

  def find_matches
    distance = (params["distance"] || 1).to_i
    first_record = (params["first_record"] || 0).to_i
    page_size = (params["page_size"] || 50).to_i
    search = params["search"] || ""
    if (params["search"]&.empty?)
      abbreviations = BrandAbbreviation.order("UPPER(abbreviation)").select("DISTINCT UPPER(abbreviation) AS abbreviation").offset(first_record).take(page_size).map{|a| a.abbreviation}
    else
      abbreviations = BrandAbbreviation.where("abbreviation ILIKE ?", "%#{search}%").order("UPPER(abbreviation)").select("DISTINCT UPPER(abbreviation) AS abbreviation").offset(first_record).take(page_size).map{|a| a.abbreviation}
    end
   # puts BrandAbbreviation.where("abbreviation ILIKE ?", "%#{search}%").select("UPPER(abbreviation) AS abbreviation").map{|a| a.abbreviation}
    brands = []
    count = 0
    synonyms = Synonym.where(:word => abbreviations).map {|s| {word: s.word, synonym: s.synonym}}
    abbreviations.each do |current|
      count = count + 1
      break if count > page_size
      matches = []
      abbreviations.each do |potential_match|
        next if current == potential_match
        next if matches.include?(potential_match)
        if DamerauLevenshtein.distance(current, potential_match) <= distance
          matches.push(potential_match)
          next
        elsif current.gsub(/[^0-9a-zA-Z]/i, '') == potential_match.gsub(/[^0-9a-zA-Z]/i, '')
          matches.push(potential_match)
          next
        elsif current.starts_with?(potential_match) || potential_match.starts_with?(current)
          matches.push(potential_match) and next
        end
        if synonyms.select { |s| s[:word] == current }.include?(potential_match)
          matches.push(potential_match)
          next
        end
      end
      matches = matches.join("<br />").html_safe
      brands.push({ :abbreviation => current, :matches => matches})
    end
    brands
  end
end