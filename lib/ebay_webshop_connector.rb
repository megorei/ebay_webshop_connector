require "ebay_webshop_connector/version"
require 'ebayr'
require 'psych'

class EbayWebshopConnector

  def initialize(config_file)
    read_in(config_file).each do |key, value|
      Ebayr.send "#{key}=", value
    end
  end

  private

  def read_in(file)
    Psych.load_file file
  end

end
