require 'active_model/naming'
require 'active_model/translation'
require 'active_model/errors'

require_relative 'validation'
require_relative 'validations/error'
require_relative 'validations/length'
require_relative 'validations/presence'
require_relative 'validations/type'

module AttrStatements
  module ErrorManager
    class << self
      def included(base)
        base.class_eval do
          extend ActiveModel::Naming
          extend ActiveModel::Translation
        end
      end
    end

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end

    def valid?
      errors.clear

      self.class.attr_statements.each do |statement_key|
        object = self.class.__send__(:get_statement_object, statement_key)
        value  = get_statement_value(statement_key)

        validate(object, value)
      end

      errors.empty?
    end

    private

    attr_writer :errors

    # :reek:FeatureEnvy
    def validate(object, value)
      Validation::VALIDATORS.each do |error_type|
        class_type = "AttrStatements::Validations::#{error_type.classify}"
        validation_class = Object.const_get(class_type)
        validation = validation_class.new(object)

        add_errors(object.key, validation.errors) unless validation.valid?(value)
      end
    end

    def add_errors(key, arr_errors)
      arr_errors.each { |error| add_error(key, error) }
    end

    # :reek:FeatureEnvy
    def add_error(key, error)
      errors.add(key, error.message, error.options)
    end

    # The following method is needed to be minimally implemented for error management
    def read_attribute_for_validation(attr)
      get_statement_value(attr)
    end
  end
end
