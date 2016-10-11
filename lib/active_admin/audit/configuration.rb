module ActiveAdmin
  module Audit
    class Configuration
      include ActiveAdmin::Settings

      # == User class name
      #
      # Set the name of the class that is used as the AdminUser.
      # Defaults to AdminUser
      #
      setting :user_class_name, :admin_user
    end
  end
end
