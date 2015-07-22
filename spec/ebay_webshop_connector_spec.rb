require 'spec_helper'

describe EbayWebshopConnector do
  ebay_spec_conf_file = '/tmp/ebay.spec_conf.yml'

  before(:all) do
    config = Psych.dump(
      dev_id: "my-dev-id",
      authorization_callback_url: "https://my-site/callback-url",
      auth_token: "myverylongebayauthtoken",
      app_id: "my-ebay-app-id",
      cert_id: "my-ebay-cert-id",
      ru_name: "my-ebay-ru-name")

    File.write ebay_spec_conf_file, config
  end

  subject do
    EbayWebshopConnector.new ebay_spec_conf_file
  end

  it 'has a version number' do
    expect(EbayWebshopConnector::VERSION).not_to be nil
  end

  it 'configures its dependency' do
    subject # initialise subject
    expect(Ebayr.dev_id).to eq 'my-dev-id'
  end
end
