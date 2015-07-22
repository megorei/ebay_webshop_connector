require 'spec_helper'

describe EbayWebshopConnector do
  ebay_dummy_conf_file = '/tmp/ebay.spec_conf.yml'
  ebay_live_conf_file = 'ebay.conf.yml'

  let(:config_file) { ebay_dummy_conf_file }

  before(:all) do
    config = Psych.dump(
      dev_id: "my-dev-id",
      authorization_callback_url: "https://my-site/callback-url",
      auth_token: "myverylongebayauthtoken",
      app_id: "my-ebay-app-id",
      cert_id: "my-ebay-cert-id",
      ru_name: "my-ebay-ru-name")

    File.write ebay_dummy_conf_file, config
  end

  subject do
    EbayWebshopConnector.new config_file
  end

  it 'has a version number' do
    expect(EbayWebshopConnector::VERSION).not_to be nil
  end

  it 'configures its dependency' do
    subject # initialise subject
    expect(Ebayr.dev_id).to eq 'my-dev-id'
  end

  unless File.exists? ebay_live_conf_file
    puts <<-ERR
    You may want to add a live Ebay sandbox configuration file
    according to this sample in order to run more tests:

    #{Psych.load_file(ebay_dummy_conf_file).to_yaml}
    ERR
  else

    describe '#get_ebay_official_time' do
      context 'with correct live Ebay sandbox authorisation' do
        let(:config_file) { ebay_live_conf_file }

        it 'retrieves the official Ebay time' do
          time = subject.get_ebay_official_time
          # Make sure your machines clock is not too wrong ;-)
          expect(time).to be_within(5.minutes).of Time.new
        end
      end

      context 'with incorrect live Ebay sandbox authorisation' do
        let(:config_file) { ebay_dummy_conf_file }

        it 'raises an EbayWebshopConnector::RetrievalError' do
          expect{ subject.get_ebay_official_time }.to raise_error EbayWebshopConnector::RetrievalError
        end
      end

    end
  end
end
