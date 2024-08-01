# frozen_string_literal: true

require 'net/http'
require 'json'
require 'uri'

module CatFinderAdaptors
  class BaseAdaptor
    def self.fetch_data
      raise NotImplementedError, 'This method should be overridden in a subclass'
    end

    def self.get_json_data(url)
      uri = URI(url)
      response = Net::HTTP.get_response(uri)

      raise "Failed to fetch data from #{url}: #{response.message}" unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body)
    rescue StandardError => e
      log_error(e)
      []
    end

    def self.log_error(error)
      Rails.logger.error(error.message)
    end
  end
end
