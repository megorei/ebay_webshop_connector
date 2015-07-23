require "ebay_webshop_connector/version"
require 'ebayr'
require 'psych'
# extend Time with parsing methods
require 'time'
require 'active_support/core_ext/string/inflections'

class EbayWebshopConnector

  CALL_PARAM_DEFAULTS = {
    warningLevel: 'High'
  }

  CONFIG_DEFAULTS = {
    compatability_level: 931,
    site_id: 77 # Ebay Germany
  }

  def initialize(config_file)
    from_yaml(config_file).each do |key, value|
      Ebayr.send "#{key}=", value
    end
  end

  def method_missing(method, *args)
    handle_call method, *args
  end

  def get_ebay_official_time
    result = handle_call :get_ebay_official_time

    Time.parse result[:timestamp]
  end

  private

  def handle_call(request_type, options = {})
    result = Ebayr.call customCamelize(request_type),
      CALL_PARAM_DEFAULTS.merge(options)

    handle_error result

    result
  end


  def handle_error(result)
    result[:errors] and
      raise EbayWebshopConnector::RetrievalError.new result[:errors]
  end

  def customCamelize(ebay_str)
    ebay_str.to_s.camelize.gsub /Ebay/, 'eBay'
  end

  def from_yaml(file)
    Psych.load_file file
  end

end

class EbayWebshopConnector::RetrievalError < StandardError; end
