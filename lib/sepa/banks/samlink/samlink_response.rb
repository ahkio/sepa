module Sepa
  # Handles Samlink specific response logic. Mainly certificate specific stuff.
  class SamlinkResponse < Response
    # @see Response#response_code
    def response_code
      [:get_certificate, :renew_certificate].include?(command) ? super(namespace: SAMLINK_PKI) : super
    end

    # @see Response#response_code
    def response_text
      [:get_certificate, :renew_certificate].include?(command) ? super(namespace: SAMLINK_PKI) : super
    end

    def application_response
      [:get_certificate, :renew_certificate].include?(command) ? super(namespace: SAMLINK_PKI) : super
    end

    def own_signing_certificate
      (node = Nokogiri::XML(application_response).at('xmlns|Certificate > xmlns|Certificate', xmlns: OP_XML_DATA)) &&
        (content = node.content) &&
        x509_certificate(decode(content)).to_s
    end

    def certificate_is_trusted?
      case environment
      when :production
        verify_certificate_against_root_certificate(certificate, SAMLINK_ROOT_CERTIFICATE)
      when :test
        verify_certificate_against_root_certificate(certificate, SAMLINK_TEST_CERTIFICATE)
      end
    end
  end
end
