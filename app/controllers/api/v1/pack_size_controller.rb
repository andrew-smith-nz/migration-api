class Api::V1::PackSizeController < Api::ApiController
  include PackSizeParser

  def interpret
   render json: parse_pack_sizes(params[:data].map { |d| OpenStruct.new(d) }).map {|p| p.marshal_dump}
  end
end