module TurboClone
  class Engine < ::Rails::Engine
    isolate_namespace TurboClone

    # https://edgeapi.rubyonrails.org/classes/ActionController/MimeResponds.html
    initializer "turbo.media_type" do
      Mime::Type.register "text/vnd.turbo-stream.html", :turbo_stream
    end

    # Load helpers into the main app
    # "turbo.helper" is just a name
    initializer "turbo.helper" do
      # When action_controller_base is loaded, load the helpers
      ActiveSupport.on_load :action_controller_base do
        helper TurboClone::Engine.helpers
      end
    end
  end
end
