require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/slice'

module AttrStatements
  class Attribute
    attr_reader :key
    attr_reader :class_type
    attr_reader :options

    def presence?
      options[:presence] == true
    end

    def length
      options.fetch(:length) { {} }
    end

    private

    OPTIONS = %i[presence length].freeze
    private_constant :OPTIONS

    attr_writer :key
    attr_writer :class_type
    attr_writer :options

    def initialize(key, class_type, options = {})
      raise ArgumentError, ':options must be a Hash' unless options.is_a?(Hash)

      self.key        = key.to_sym
      self.class_type = class_type.is_a?(String) ? Object.const_get(class_type) : class_type
      self.options    = options.with_indifferent_access.slice(*Validation::VALIDATORS)
    end
  end
end
