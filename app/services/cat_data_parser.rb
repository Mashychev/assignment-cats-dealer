# frozen_string_literal: true

require 'json'
require 'nokogiri'

class CatDataParser
  def self.parse_json(json)
    JSON.parse(json)
  end

  def self.parse_xml(xml)
    doc = Nokogiri::XML(xml)

    doc.xpath('//cat').each_with_object([]) do |cat_node, cats_list|
      cat = {
        'name' => cat_node.at_xpath('title').text,
        'price' => cat_node.at_xpath('cost').text.to_i,
        'location' => cat_node.at_xpath('location').text,
        'image' => cat_node.at_xpath('img').text
      }
      cats_list << cat
    end
  end
end
