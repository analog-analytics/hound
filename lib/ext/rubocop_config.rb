class RuboCopConfig
  def initialize(default_config:, custom_config:)
    @default_config = default_config
    @custom_config = custom_config || {}
  end

  def generate
    RuboCop::Config.new(merged_config, "")
  end

  private

  attr_reader :default_config, :custom_config

  def merged_config
    RuboCop::ConfigLoader.merge(
      normalize_config(default_config),
      normalize_config(custom_config)
    )
  # rescue TypeError
  #   normalize_config(default_config)
  end

  def normalize_config(config)
    RuboCop::Config.new(config, "").tap do |rubocop_config|
      rubocop_config.add_missing_namespaces
      rubocop_config.make_excludes_absolute
    end
  # rescue NoMethodError
  #   RuboCop::Config.new
  end
end