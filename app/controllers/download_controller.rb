class DownloadController < ApplicationController
  require 'httparty'
  # POST /download
	def get
    #Obtiene una lista de todos los parametros enviados, ignorando los strong params
    allParams = params.to_unsafe_h
    #Si hay parametros adicionales a los necesarios para actualizar, se manda el error.
    unpermitted = allParams.slice!(:url, :download, :controller, :action)
    #si hay uno o mas parametros no aceptados, se manda el error
    if unpermitted.length == 0

      sanitized_url = params[:url]
      raw_url = URI.parse(sanitized_url)
      filename = raw_url.path.split('/').last
      path = Rails.root + 'tmp/' + filename

      File.open(path, "wb") do |f| 
        response = HTTParty.get(sanitized_url)
        case response.code
          when 200
            f.write response.body
          when 404
            render json:
            {
              message: "Not Found",
              code: 404,
              description: "URL was not found on server"
            }, status: 404
            return
          when 500...600
            render json:
            {
              message: "Internal Server Error",
              code: 500,
              description: "Unexpected error #{response.code}"
            }, status: 500
            return
        end
      end
      
      send_file path, filename: filename, type: "audio/mp3", disposition: "attachment"

    else
      render json:
        {
          message: "Bad Request",
          code: 400,
          description: "Parameters: #{unpermitted} not valid"
        }, status: 400
    end
	end
end
