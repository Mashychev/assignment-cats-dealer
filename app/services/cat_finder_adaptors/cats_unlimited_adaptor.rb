# frozen_string_literal: true

require 'net/http'
require 'json'
require 'uri'

module CatFinderAdaptors
  class CatsUnlimitedAdaptor < BaseAdaptor
    def self.fetch_data
      get_json_data(ENV.fetch('CATS_UNLIMITED_URL'))
    end
  end
end
