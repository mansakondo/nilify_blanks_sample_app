class NilifyBlanksType < ActiveRecord::Type::Value
  attr_reader :type, :options

  def initialize(type:, **options)
    @type    = type
    @options = options
  end

  def cast_type
    @cast_type ||= lookup_or_return_cast_type
    @cast_type
  end

  def cast(value)
    return unless value

    evaluated_value = eval value rescue nil
    value           = evaluated_value if evaluated_value
    nilified_value  = nilify value

    cast_type.cast(nilified_value)
  end

  def serialize(value)
    return unless value

    nilified_value = cast value

    cast_type.serialize(nilified_value)
  end

  def deserialize(value)
    return unless value

    cast_type.deserialize(value)
  end

  private
    def nilify(value)
      return value unless nilifiable? value

      case value
      when String
        nilify_string(value)
      when Array
        nilify_array(value)
      when Hash
        nilify_hash(value)
      end
    end

    def nilify_string(string)
      nil
    end

    def nilify_array(array)
      return nil if array.empty?

      nilified_array = array.reject(&:blank?)

      nilified_array.empty? ? nil : nilified_array
    end

    def nilify_hash(hash)
      return nil if hash.empty?

      nilified_hash = hash.reject do |_key, value|
        value.blank?
      end

      nilified_hash.empty? ? nil : nilified_hash
    end

    def nilifiable?(value)
      case value
      when String
        nilifiable_string?(value)
      when Array
        nilifiable_array?(value)
      when Hash
        nilifiable_hash?(value)
      else
        false
      end
    end

    def nilifiable_string?(string)
      string.blank?
    end

    def nilifiable_array?(array)
      return true if array.empty?

      array.any?(&:blank?)
    end

    def nilifiable_hash?(hash)
      return true if hash.empty?

      hash.any? do |_key, value|
        value.blank?
      end
    end

    def lookup_or_return_cast_type
      case type
      when Symbol
        ActiveRecord::Type.lookup(type, **options)
      when Array
        ActiveRecord::Type.lookup(type.first, **options.merge(array: true))
      when Class
        type
      else
        nil
      end
    end
end
