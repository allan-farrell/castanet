require File.expand_path('../../../spec_helper', __FILE__)

shared_examples_for 'a service ticket' do
  def ticket
    raise "A 'ticket' method must be defined in the host group"
  end

  def validation_url
    raise "A 'validation_url' method must be defined in the host group"
  end

  let(:logger) { stub }
  let(:service) { 'https://service.example.edu/' }
  let(:proxy_callback_url) { 'https://cas.example.edu/callback/receive_pgt' }
  let(:proxy_retrieval_url) { 'https://cas.example.edu/callback/retrieve_pgt' }

  describe '#initialize' do
    it 'wraps a textual ticket' do
      ticket.ticket.should == ticket_text
    end

    it 'sets the expected service' do
      ticket.service.should == service
    end
  end

  describe '#present!' do
    before do
      stub_request(:any, /.*/)
    end

    it 'validates its ticket for the given service' do
      ticket.present!

      a_request(:get, validation_url).
        with(:query => { 'ticket' => ticket_text, 'service' => service }).
        should have_been_made.once
    end

    it 'sends proxy callback URLs to the service ticket validator' do
      ticket.proxy_callback_url = proxy_callback_url

      ticket.present!

      a_request(:get, validation_url).
        with(:query => { 'ticket' => ticket_text, 'service' => service,
             'pgtUrl' => proxy_callback_url }).
        should have_been_made.once
    end

    it 'warns when a non-HTTPS connection is established' do
      url = validation_url.sub(/^https/, 'http')
      ticket.logger = logger
      ticket.stub!(:validation_url => url)

      logger.should_receive(:warn).once.with(/#{url} will not be accessed over HTTPS/i)

      ticket.present!
    end
  end

  describe '#retrieve_pgt!' do
    before do
      stub_request(:any, /.*/)

      ticket.proxy_retrieval_url = proxy_retrieval_url
      ticket.stub!(:pgt_iou => 'PGTIOU-1foo')
    end

    it 'fetches a PGT from the callback URL' do
      ticket.retrieve_pgt!

      a_request(:get, proxy_retrieval_url).
        with(:query => { 'pgtIou' => 'PGTIOU-1foo' }).
        should have_been_made.once
    end

    it 'stores the retrieved PGT in #pgt' do
      stub_request(:get, /.*/).to_return(:body => 'PGT-1foo')

      ticket.retrieve_pgt!

      ticket.pgt.should == 'PGT-1foo'
    end

    it 'warns when a non-HTTPS connection is established' do
      ticket.logger = logger
      ticket.proxy_retrieval_url = 'http://cas.example.edu/callback/retrieve_pgt'

      logger.should_receive(:warn).once.with(/#{ticket.proxy_retrieval_url} will not be accessed over HTTPS/i)

      ticket.retrieve_pgt!
    end
  end

  describe '#ok?' do
    it 'delegates to the validation response' do
      ticket.response = stub(:ok? => true)

      ticket.should be_ok
    end
  end

  describe '#username' do
    it 'delegates to the validation response' do
      ticket.response = stub(:username => 'username')

      ticket.username.should == 'username'
    end
  end
end
