module ActiveAdmin
  module Audit
    module ControllerHelper
      def user_for_paper_trail
        send(ActiveAdmin.application.current_user_method)
      end

      def paper_trail_enabled_for_controller
        request.fullpath.start_with?('/admin')
      end
    end
  end
end
