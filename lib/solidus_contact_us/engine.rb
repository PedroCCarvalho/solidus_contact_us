# frozen_string_literal: true

module SolidusContactUs
  class Engine < Rails::Engine
    isolate_namespace Spree
    engine_name 'solidus_contact_us'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    config.autoload_paths += %W(#{config.root}/lib)

    initializer 'solidus_contact_us.environment', before: :load_config_initializers do
      SolidusContactUs::Config = SolidusContactUs::Configuration.new
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
