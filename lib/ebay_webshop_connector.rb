require "ebay_webshop_connector/version"
require 'ebayr'
require 'psych'
# extend Time with parsing methods
require 'time'

class EbayWebshopConnector

  WARNING_LEVEL = 'High'

  def initialize(config_file)
    read_in(config_file).each do |key, value|
      Ebayr.send "#{key}=", value
    end
  end

  def get_ebay_official_time
    result = Ebayr.call :GeteBayOfficialTime

    handle_error result

    Time.parse result[:timestamp]
  end

  def get_suggested_categories(query)
    result = Ebayr.call :GetSuggestedCategories,
      query: query,
      warningLevel: WARNING_LEVEL

    handle_error result

    result
  end

  private

  def handle_error(result)
    result[:errors] and
      raise EbayWebshopConnector::RetrievalError.new result[:errors]
  end

  def read_in(file)
    Psych.load_file file
  end

end

class EbayWebshopConnector::RetrievalError < StandardError; end
