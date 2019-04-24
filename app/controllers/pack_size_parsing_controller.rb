class PackSizeParsingController < ApplicationController
  include PackSizeParser

  def index
   @parsed_pack_sizes = parse_pack_sizes PackSize.offset(20000).take(1500)
   #@parsed_pack_sizes = parse_pack_sizes PackSize.where('id IN (9976)')
    render
  end
end