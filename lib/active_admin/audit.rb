require 'active_admin'
require 'active_admin/audit/configuration'
require 'active_admin/audit/version'
require 'active_admin/audit/engine'
require 'active_admin/audit/controller_helper'
require 'active_admin/audit/has_versions'
require 'active_admin/audit/version_snapshot'
require 'active_admin/views/latest_versions'
require 'active_admin/versions_helper'

module ActiveAdmin
  module Audit
    class << self
      attr_accessor :configuration

      def configuration
        @configuration ||= ::ActiveAdmin::Audit::Configuration.new
      end

      # Gets called within the initializer
      def setup
        yield(configuration)
      end
    end
  end
end
