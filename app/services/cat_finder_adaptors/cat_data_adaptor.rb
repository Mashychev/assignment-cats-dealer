require 'net/http'
require 'json'
require 'uri'

module CatFinderAdaptors
  class CatDataAdaptor
    def self.fetch_data
      raise NotImplementedError, 'This method should be overridden in a subclass'
    end

    private

    def self.get_json_data(url)
      uri = URI(url)
      response = Net::HTTP.get_response(uri)

      if response.is_a?(Net::HTTPSuccess)
        JSON.parse(response.body)
      else
        raise "Failed to fetch data from #{url}: #{response.message}"
      end
    rescue => e
      log_error(e)
      []
    end
  end
end