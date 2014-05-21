module RailsAttrEnum
  module Enum
    def self.included(base)
      base.extend(ClassMethods)
      base.instance_variable_set(:@_enum_members, {})
    end

    module ClassMethods
      def value(key)
        get(key).value
      end
      alias_method :[], :value

      def label(key)
        get(key).label
      end

      def get_label(value)
        get_by_value(value).label
      end

      def get_key(value)
        get_by_value(value).key
      end

      def keys
        mapped(:key)
      end

      def values
        mapped(:value)
      end

      def labels
        mapped(:label)
      end

      def label_value_pairs(*keys)
        if keys.empty?
          each_member.map { |member| [member.label, member.value] }
        else
          keys.reduce([]) do |array, key|
            member = get(key)
            array << [member.label, member.value]
          end
        end
      end

      def to_h(options = {})
        options = options.dup

        build_key = if options.delete(:use_constant_keys)
          proc { |member| member.key.to_s.camelize }
        else
          proc { |member| member.key }
        end

        Hash[each_member.map do |member|
          [build_key.call(member), member.serialized_value(options)]
        end]
      end

      def to_json(options = {})
        to_h(options).to_json
      end

      private

      def get(key)
        @_enum_members[key]
      end

      def get_by_value(value)
        (@_enum_members_by_value ||= Hash[each_member.map do |member|
          [member.value, member]
        end])[value]
      end

      def each_member
        if block_given?
          @_enum_members.each { |_, member| yield member }
        else
          to_enum(:each_member)
        end
      end

      def mapped(field)
        each_member.map { |member| member.send(field) }
      end
    end
  end
end
