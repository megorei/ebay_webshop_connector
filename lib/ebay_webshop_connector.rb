require "ebay_webshop_connector/version"
require 'ebayr'
require 'psych'
# extend Time with parsing methods
require 'time'

class EbayWebshopConnector

  def initialize(config_file)
    read_in(config_file).each do |key, value|
      Ebayr.send "#{key}=", value
    end
  end

  def get_ebay_official_time
    result = Ebayr.call :GeteBayOfficialTime

    if result[:ack] == 'Success'
      return Time.parse result[:timestamp]
    end

    if result[:errors]
      raise EbayWebshopConnector::RetrievalError.new result[:errors]
    end
  end

  private

  def read_in(file)
    Psych.load_file file
  end

end

class EbayWebshopConnector::RetrievalError < StandardError; end
