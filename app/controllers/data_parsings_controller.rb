class DataParsingsController < ApplicationController
  include PackSizeParser

  def index
   #@parsed_pack_sizes = parse_pack_sizes PackSize.offset(5000).take(5000)
   @parsed_pack_sizes = parse_pack_sizes PackSize.where('id IN (9976)')
    render
  end
end