module ActiveAdmin
  module VersionsHelper
    BOOLEAN_VALUES = [true, false].freeze

    def pretty_version_attribute_value(attr, value)
      case value
      when Array
        Arbre::Context.new(context: self) do
          text_node attr.humanize.singularize
          ul do
            value.each do |v|
              li { context.pretty_version_attribute_value(attr, v).html_safe }
            end
          end
        end.to_s
      when Hash
        Arbre::Context.new(context: self) do
          text_node attr.humanize.singularize
          ul do
            value.each do |k, v|
              li { "#{k.humanize}: #{context.pretty_version_attribute_value(k, v)}".html_safe }
            end
          end
        end.to_s
      when /\.(jpg|png|gif)\z/i
        image_tag value
      when ActiveRecord::Base
        pretty_format(value)
      else
        value
      end
    end

    def version_attributes_diff(changes)
      Arbre::Context.new do
        ul do
          changes.keys.sort.each { |attr| li(attr.humanize) }
        end
      end.to_s
    end

    def versions_diff_classes(removed, added)
      if (added.present? && removed.present?) || (BOOLEAN_VALUES.include?(added) && BOOLEAN_VALUES.include?(removed))
        old_class = 'changed'
        new_class = old_class
      elsif added.present? || BOOLEAN_VALUES.include?(added)
        new_class = 'added'
      elsif removed.present? || BOOLEAN_VALUES.include?(removed)
        old_class = 'removed'
      end

      [old_class, new_class]
    end
  end
end