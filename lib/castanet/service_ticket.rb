require 'forwardable'
require 'openssl'
require 'uri'

require 'castanet/query_building'
require 'castanet/responses'

module Castanet
  class ServiceTicket
    extend Forwardable
    include Responses
    include QueryBuilding

    ##
    # The client that issued this ticket.
    attr_reader :client

    def_delegators :client,
      :https_required,
      :logger,
      :proxy_callback_url,
      :proxy_retrieval_url,
      :service_validate_url,
      :ssl_context

    ##
    # The wrapped service ticket.
    #
    # @return [String, nil]
    attr_reader :ticket

    ##
    # The wrapped service URL.
    #
    # @return [String, nil]
    attr_reader :service

    ##
    # The response from the CAS server.
    #
    # {ServiceTicket} sets this attribute whilst executing {#present!}, but it
    # can be manually set for e.g. testing purposes.
    #
    # @return [#ok?, #pgt_iou]
    attr_accessor :response

    def_delegators :response, :ok?, :pgt_iou, :username

    ##
    # The PGT associated with this service ticket.
    #
    # This is set after a successful invocation of {#retrieve_pgt!}.
    #
    # @return [String, nil]
    attr_accessor :pgt

    def initialize(ticket, service, client)
      @client = client
      @service = service
      @ticket = ticket
    end

    ##
    # Validates `ticket` for the service URL given in `service`.  If
    # {#proxy_callback_url} is not nil, also attempts to retrieve the PGTIOU
    # for this service ticket.
    #
    # CAS service tickets are one-time-use only
    # =========================================
    #
    # This method checks `ticket` against `service` using the CAS server, so you
    # must take care to only validate a given `ticket` _once_.
    #
    # Since ServiceTicket does not maintain any state with regard to whether a
    # ServiceTicket instance has already been presented, multiple presentations
    # of the same ticket will result in behavior like this:
    #
    #     st = service_ticket(ticket, service)
    #     st.present!
    #
    #     st.ok? # => true
    #
    #     st.present!
    #
    #     st.ok? # => false
    #
    # @see http://www.jasig.org/cas/protocol CAS 2.0 protocol, sections 2.5 and
    #   3.1.1
    #
    # @return void
    def present!
      uri = URI.parse(validation_url).tap do |u|
        u.query = validation_parameters
      end

      net_http(uri).start do |h|
        cas_response = h.get(uri.request_uri)
        log_response(cas_response, uri)

        self.response = parsed_ticket_validate_response(cas_response.body)
      end
    end

    ##
    # Retrieves a PGT from {#proxy_retrieval_url} using the PGT IOU.
    #
    # CAS 2.0 does not specify whether PGTIOUs are one-time-use only.
    # Therefore, Castanet does not prevent multiple invocations of
    # `retrieve_pgt!`; however, it is safest to assume that PGTIOUs are
    # one-time-use only.
    #
    # This method assumes the following about the PGT retrieval service:
    #
    # 1. The PGT can be retrieved using a GET request on
    #    {#proxy_retrieval_url}.
    # 2. No particular headers are required.
    # 3. The service expects the PGTIOU to be sent as a `pgtIou` parameter in
    #    the query string.
    # 4. The body of success responses from the service is precisely the PGT.
    #    (So, no XML tags, JSON syntax, etc. will be present in the
    #    response.)
    # 5. A non-success response is issued from the service is a service
    #    error.  In this case, this method raises
    #    {Castanet::ProxyTicketError}.
    #    The response code and body, if any, will be present in the exception
    #    message.
    #
    # @raise Castanet::ProxyTicketError
    # @return void
    def retrieve_pgt!
      uri = URI.parse(proxy_retrieval_url).tap do |u|
        u.query = query(['pgtIou', pgt_iou])
      end

      net_http(uri).start do |h|
        response = h.get(uri.request_uri)
        log_response(response, uri)

        body = response.body

        case response
        when Net::HTTPSuccess
          self.pgt = body
        else
          raise Castanet::ProxyTicketError, <<-END
          A PGT could not be issued.  The PGT service at #{proxy_retrieval_url}
          returned code #{response.code}, body #{body}."
          END
        end
      end
    end

    ##
    # The URL to use for ticket validation.
    #
    # @return [String]
    def validation_url
      service_validate_url
    end

    protected

    ##
    # Creates a new {Net::HTTP} instance which can be used to connect
    # to the designated URI.
    #
    # @return [Net::HTTP]
    def net_http(uri)
      logger.debug { "Request to #{uri}: ssl_context=#{ssl_context.inspect}" }

      Net::HTTP.new(uri.host, uri.port).tap do |h|
        configure_ssl(h, ssl_context) if use_ssl?(uri.scheme)
      end
    end

    def log_response(resp, uri)
      logger.debug { "Response from #{uri}: status=#{resp.code}, body=#{resp.body}" }
    end

    private

    def configure_ssl(h, ssl)
      h.use_ssl      = true
      h.verify_mode  = ssl[:verify_mode] || OpenSSL::SSL::VERIFY_PEER

      h.ca_file      = ssl[:ca_file]      if ssl[:ca_file]
      h.ca_path      = ssl[:ca_path]      if ssl[:ca_path]
      h.cert         = ssl[:client_cert]  if ssl[:client_cert]
      h.cert_store   = ssl[:cert_store]   if ssl[:cert_store]
      h.key          = ssl[:client_key]   if ssl[:client_key]
      h.verify_depth = ssl[:verify_depth] if ssl[:verify_depth]
    end

    ##
    # Builds a query string for use with the `serviceValidate` service.
    #
    # @see http://www.jasig.org/cas/protocol CAS 2.0 protocol, section 2.5.1
    # @param [String] ticket a service ticket
    # @param [String] service a service URL
    # @return [String] a query component of a URI
    def validation_parameters
      query(['ticket',  ticket],
            ['service', service],
            ['pgtUrl',  proxy_callback_url])
    end

    ##
    # Determines whether to use SSL based on the the given URI scheme and the
    # {#https_required} attribute.
    #
    # @raise if the scheme is `http` but {#https_required} is true
    # @return [Boolean]
    def use_ssl?(scheme)
      case scheme.downcase
      when 'https'
        true
      when 'http'
        raise 'Castanet requires SSL for all communication' if https_required
        false
      else
        fail "Unexpected URI scheme #{scheme.inspect}"
      end
    end
  end
end
