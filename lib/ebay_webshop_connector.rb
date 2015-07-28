require "ebay_webshop_connector/version"
require 'ebayr'
require 'psych'
# extend Time with parsing methods
require 'time'
require 'active_support/core_ext/string/inflections'
require 'json'

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
    return unless result[:errors]

    errors = result[:errors]
    errors = [errors] unless errors.is_a?(Array)

    # http://developer.ebay.com/devzone/client-alerts/docs/CallRef/types/SeverityCodeType.html
    only_warnings = errors.all?{ |error_hash| error_hash[:severity_code] == 'Warning' }
    if only_warnings
      Kernel.warn JSON.pretty_generate errors
    else
      raise EbayWebshopConnector::RetrievalError.new JSON.pretty_generate errors
    end
  end

  def customCamelize(ebay_str)
    ebay_str.to_s.camelize.gsub /Ebay/, 'eBay'
  end

  def from_yaml(file)
    Psych.load_file file
  end

end

class EbayWebshopConnector::RetrievalError < StandardError; end
