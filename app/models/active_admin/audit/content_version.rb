module ActiveAdmin
  module Audit
    class ContentVersion < PaperTrail::Version
      serialize :object, VersionSnapshot
      serialize :object_changes, VersionSnapshot

      serialize :additional_objects, VersionSnapshot
      serialize :additional_objects_changes, VersionSnapshot

      def object_changes
       ignore = %w(id created_at updated_at)
       super.reject { |k, _| ignore.include?(k) }
      end

      def object_snapshot
        object.materialize(item_class)
      end

      def additional_objects_snapshot
        additional_objects.materialize(item_class)
      end

      def object_snapshot_changes
        object_changes.materialize(item_class)
      end

      def additional_objects_snapshot_changes
        additional_objects_changes.materialize(item_class)
      end

      def who
        AdminUser.find_by(id: whodunnit)
      end

      def item_class
        item_type.constantize
      rescue NameError
        ActiveRecord::Base
      end

      def item
        super
      rescue NameError
        nil
      end
    end
  end
end