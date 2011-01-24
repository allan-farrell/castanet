require 'castanet'

%%{
  machine proxy;

  include common "common.rl";

  # Actions
  # -------

  action save_failure_code { r.failure_code = buffer; buffer = '' }
  action save_failure_reason { r.failure_reason = buffer.strip; buffer = '' }
  action save_pt { r.ticket = buffer; buffer = '' }
  action set_success { r.ok = true }

  # Leaf tags
  # ---------

  proxy_ticket = "<cas:proxyTicket>"
                 ( ticket_character @buffer )*
                 "</cas:proxyTicket>" %save_pt;

  # Non-leaf tags
  # -------------

  proxy_success_start = "<cas:proxySuccess>";
  proxy_success_end   = "</cas:proxySuccess>";

  proxy_failure_start = "<cas:proxyFailure code="
                        quote
                        failure_code %save_failure_code
                        quote
                        ">";
  proxy_failure_end   = "</cas:proxyFailure>";

  # Top-level elements
  # ------------------

  success = service_response_start
            space*
            proxy_success_start
            space*
            proxy_ticket
            space*
            proxy_success_end
            space*
            service_response_end @set_success;

  failure = service_response_start
            space*
            proxy_failure_start
            failure_reason %save_failure_reason
            proxy_failure_end
            space*
            service_response_end;

  main := success | failure;
}%%

module Castanet::Responses
  class Proxy
    ##
    # Whether or not a proxy ticket could be issued.
    #
    # @return [Boolean]
    attr_accessor :ok

    alias_method :ok?, :ok

    ##
    # The proxy ticket issued by the CAS server.
    #
    # If {#ok} is false, this will be `nil`.
    #
    # @return [String, nil]
    attr_accessor :ticket

    ##
    # On ticket issuance failure, contains the code identifying the
    # nature of the failure.
    #
    # On success, is nil.
    #
    # @see http://www.jasig.org/cas/protocol CAS protocol, sections 2.7.2 and 2.7.3
    # @return [String, nil]
    attr_accessor :failure_code

    ##
    # On ticket issuance failure, contains the failure reason.
    #
    # On success, is nil.
    #
    # @see http://www.jasig.org/cas/protocol CAS protocol, section 2.7.2
    # @return [String, nil]
    attr_accessor :failure_reason

    ##
    # Generates a {Proxy} object from a CAS response.
    #
    # @param [String] response the CAS response
    # @return [Proxy]
    def self.from_cas(response)
      data = response.strip.unpack('U*')
      buffer = ''

      %% write init;

      new.tap do |r|
        %% write exec;
      end
    end

    %% write data;
  end
end