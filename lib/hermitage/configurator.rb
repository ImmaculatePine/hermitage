module Hermitage

  class Configurator

    Defaults.constants.each do |c|
      define_method c.downcase do |value|
        @config.merge!({ c.downcase.to_sym => value })
      end
    end

    def respond_to?(method_name)
      Defaults.constants.include? method_name.upcase.to_sym || super
    end

    def initialize(config_name, &block)
      Hermitage.configs[config_name] ||= {}
      @config = Hermitage.configs[config_name]
      self.instance_eval(&block) if block_given?
    end

    # Returns full options hash for specified objects and options.
    # It chooses config accoring to the class name of objects in passed array
    # and merges default options with the chosen config and with passed options hash.
    def self.options_for(objects, options = {})
      config_name = objects.first.class.to_s.pluralize.underscore.to_sym if defined?(Rails) && !objects.empty?
      config = Hermitage.configs[config_name] || Hermitage.configs[:default]
      Hermitage.configs[:default].merge(config).merge(options)
    end
  end

end