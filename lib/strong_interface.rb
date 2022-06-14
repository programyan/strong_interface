# frozen_string_literal: true

require 'strong_interface/version'
require 'strong_interface/parameters_validator'

module StrongInterface
  ImplementationError = Class.new(StandardError)
  UnknownStrategy = Class.new(StandardError)

  RAISING_STRATEGIES = {
    'raise' => ->(error) { raise ImplementationError, error },
    'log' => ->(error) { Logger.new($stdout).warn { error } }
  }.freeze

  # @param interfaces [Module|Class|Array<Module|Class>] the list of interfaces that class or module should implements
  #
  # @raise [UnknownStrategy] if SI_VALIDATION_STRATEGY environment variable has wrong value
  # @raise [ImplementationError] if describing some methods of an interface has been forgotten and
  #                              SI_VALIDATION_STRATEGY environment variable is set to `raise`
  def implements(interfaces)
    TracePoint.trace(:end) do |t|
      next if self != t.self

      errors_strategy = ENV.fetch('SI_VALIDATION_STRATEGY', 'raise')
      raise UnknownStrategy, errors_strategy if RAISING_STRATEGIES[errors_strategy].nil?

      errors = validate(interfaces)

      RAISING_STRATEGIES[errors_strategy].call(errors.join("\n")) unless errors.empty?

      t.disable
    end
  end

  private

  def validate(interfaces)
    Array(interfaces).flat_map do |interface|
      validate_constants(interface) + validate_class_methods(interface) + validate_instance_methods(interface)
    end
  end

  def validate_constants(interface)
    (interface.constants - constants).map do |missing_constant|
      "Constant `#{missing_constant}` is absent at `#{self}`"
    end
  end

  def validate_class_methods(interface)
    interface.methods(false).filter_map do |klass_method|
      if !methods(false).include?(klass_method)
        "Class method `#{klass_method}` is not implemented at `#{self}`"
      else
        ParametersValidator.new(interface.method(klass_method), method(klass_method)).validate
      end
    end
  end

  def validate_instance_methods(interface)
    interface.instance_methods.filter_map do |instance_method|
      if !instance_methods.include?(instance_method)
        "Instance method `#{instance_method}` is not implemented at `#{self}`"
      else
        ParametersValidator.new(interface.instance_method(instance_method), instance_method(instance_method)).validate
      end
    end
  end
end
