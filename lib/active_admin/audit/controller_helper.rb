module ActiveAdmin
  module Audit
    module ControllerHelper
      def user_for_paper_trail
        current_admin_user
      end

      def paper_trail_enabled_for_controller
        request.fullpath.start_with?('/admin')
      end
    end
  end
end