module TurboClone
  class Engine < ::Rails::Engine
    isolate_namespace TurboClone

    # Load helpers into the main app
    initializer "turbo.helper" do
      # When action_controller_base is loaded, load the helpers
      ActiveSupport.on_load :action_controller_base do
        helper TurboClone::Engine.helpers
      end
    end
  end
end
