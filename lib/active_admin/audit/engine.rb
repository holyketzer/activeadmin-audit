require 'rails/engine'

module ActiveAdmin
  module Audit
    class Engine < Rails::Engine
      isolate_namespace ActiveAdmin::Audit

      initializer 'load_config_initializers' do |app|
        PaperTrail.serializer = PaperTrail::Serializers::JSON

        app_path = File.expand_path('../../../../app/admin', __FILE__)
        ActiveAdmin.application.load_paths.unshift(app_path)

        module ActiveAdmin::ViewHelpers
          include ActiveAdmin::VersionsHelper
        end
      end

      initializer 'active_record.set_configs' do
        ActiveSupport.on_load(:active_record) do
          include ActiveAdmin::Audit::HasVersions
        end
      end
    end
  end
end
