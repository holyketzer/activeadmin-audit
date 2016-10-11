require 'rails/generators/active_record'

module ActiveAdminAudit
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      desc "Installs Active Admin Audit and generates the necessary configurations"
      argument :name, type: :string, default: "AdminUser"

      source_root File.expand_path("../templates", __FILE__)

      def copy_initializer
        @underscored_user_name = name.underscore.gsub('/', '_')
        template 'active_admin.audit.rb.erb', 'config/initializers/active_admin_audit.rb'
      end
    end
  end
end
