require "turbo_clone/version"
require "turbo_clone/engine"

module TurboClone
  class <<self
    attr_writer :signed_stream_verifier_key

    def signed_stream_verifier
      @signed_stream_verifier ||=
        # digest more secure
        # serializer easier (default Marshal)
        ActiveSupport::MessageVerifier.new(signed_stream_verifier_key, digest: "SHA256", serializer: JSON)
    end

    # getter with error
    def signed_stream_verifier_key
        @signed_stream_verifier_key or raise ArgumentError, "Turbo requires a signed_stream_verifier_key"
    end
  end
end
