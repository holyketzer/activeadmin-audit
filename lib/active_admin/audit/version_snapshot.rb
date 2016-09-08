module ActiveAdmin
  module Audit
    class VersionSnapshot < HashWithIndifferentAccess
      def self.dump(snapshot)
        snapshot.to_json
      end

      def self.load(string)
        self[JSON.parse(string || '{}')]
      end

      def diff(other_snapshot)
        keys = (self.keys + other_snapshot.keys).uniq

        keys.each_with_object({}) do |key, diff|
          old_value = self[key]
          new_value = other_snapshot[key]

          if old_value.class == new_value.class
            item_diff = {}

            added = new_value - old_value
            item_diff[:+] = added unless added.empty?

            removed = old_value - new_value
            item_diff[:-] = removed unless removed.empty?

            diff[key] = item_diff unless item_diff.empty?
          end
        end
      end

      def materialize(klass)
        each do |attr, values|
          self[attr] =
            if values.is_a? Array
              # array of any values
              values.map { |value| materialize_item(klass, attr, value) }
            elsif values.is_a? Hash
              # hash with diff in '+'/'-'
              values.each do |k, items|
                values[k] = items.map { |value| materialize_item(klass, attr, value) }
              end
            else
              # any values
              materialize_item(klass, attr, values)
            end
        end
      end

      private

      def materialize_item(klass, attr, value)
        if (association = klass.reflect_on_all_associations.find { |a| [a.foreign_key, a.plural_name, a.name.to_s].include?(attr) })
          # attr is association in klass
          if value.is_a?(Hash)
            if value.size == 1 && value.keys.first.to_s == association.klass.primary_key.to_s
              # has_many/has_one
              materialize_record_value(association.klass, value.values.first)
            else
              # nested item
              value.each do |key, v|
                value[key] = materialize_item(association.klass, key, v)
              end
            end
          elsif value.is_a?(Integer) || value =~ /\d+/
            # belongs_to
            materialize_record_value(association.klass, value)
          end
        else
          value
        end
      end

      def materialize_record_value(klass, value)
        klass.find_by(id: value) || "#{klass} ##{value} was removed"
      end
    end
  end
end