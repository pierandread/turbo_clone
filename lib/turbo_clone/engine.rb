require "turbo_clone/test_assertions"

module TurboClone
  class Engine < ::Rails::Engine
    isolate_namespace TurboClone

    # Hash without bracket (a la js)
    config.turbo = ActiveSupport::OrderedOptions.new

    initializer 'turbo.signed_stream_verifier_key' do
      TurboClone.signed_stream_verifier_key = config.turbo.signed_stream_verifier_key ||
        # string arg can be anything
        Rails.application.key_generator.generate_key("turbo/signed_stream_verifier_key")
    end

    # https://edgeapi.rubyonrails.org/classes/ActionController/MimeResponds.html
    initializer "turbo.media_type" do
      Mime::Type.register "text/vnd.turbo-stream.html", :turbo_stream
    end

    # Load helpers into the main app
    # "turbo.helper" is just a name
    initializer "turbo.helper" do
      # When action_controller_base is loaded, load the helpers
      ActiveSupport.on_load :action_controller_base do
        # To add method to all controllers
        include TurboClone::Streams::TurboStreamsTagBuilder
        #
        helper TurboClone::Engine.helpers
      end
    end

    initializer "turbo.helper" do
      ActiveSupport.on_load :active_record do
        include TurboClone::Broadcastable
      end
    end

    initializer "turbo.renderer" do
      ActiveSupport.on_load :action_controller do
        ActionController::Renderers.add :turbo_stream do |turbo_streams_html, options|
          turbo_streams_html
        end
      end
    end

    initializer "turbo.test_assertions" do
      ActiveSupport.on_load :active_support_test_case do
        include TurboClone::TestAssertions
      end
    end

    # To be able to pass as: :turbo_stream inside integration test
    initializer "turbo.integration_test_request_encoding" do
      ActiveSupport.on_load :action_dispatch_integration_test do
        class ActionDispatch::RequestEncoder
          class TurboStreamEncoder < IdentityEncoder
            header = [Mime[:turbo_stream], Mime[:html]].join(",")
            define_method(:accept_header) { header }
          end

          @encoders[:turbo_stream] = TurboStreamEncoder.new
        end
      end
    end
  end
end
