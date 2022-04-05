module Interpolation

  DEFAULT_INTERPOLATION_PATTERNS = [
    /%%/,
    /%\{([\w|]+)\}/,                            # matches placeholders like "%{foo} or %{foo|word}"
  ].freeze
  INTERPOLATION_PATTERN = Regexp.union(DEFAULT_INTERPOLATION_PATTERNS)

  class << self

    def interpolate(string, values)
      raise ArgumentError.new('Interpolation values must be a Hash.') unless values.kind_of?(Hash)
      return '' if string.nil?
      interpolate_hash(string, values)
    end

    def interpolate_hash(string, values)
      string.gsub(INTERPOLATION_PATTERN) do |match|
        if match == '%%'
          '%'
        else
          key = ($1 || $2 || match.tr("%{}", "")).to_sym
          value = if values.key?(key)
                    values[key]
                  end
          value = value.call(values) if value.respond_to?(:call)
          $3 ? sprintf("%#{$3}", value) : value
        end
      end
    end
  end
end
