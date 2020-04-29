module QuestEngine
  class ConditionParser

    CONSTANTS = %w[true false].freeze
    DELIMITERS = %w[> < ==].freeze
    OPERATORS = %w[+ -].freeze
    VALID_SYMBOLS = CONSTANTS + DELIMITERS + OPERATORS
    CONSTANTS_MAP = {'true': '#', 'false': '$'}.freeze

    def valid_condition?(keys, condition)
      valid_symbols?(keys, condition) && single_delimiter?(condition)
    end

    def allowed_condition?(state, condition)
      expr = decorate_constants(condition.dup)
      dlm = delimiter(expr).to_sym
      lhs, rhs = decorate_constants(expr).split(dlm.to_s)
      state.sort_by { |k, _| k.length }.reverse.each do |k, v|
        lhs.gsub!(k.to_s, v.to_s)
        rhs.gsub!(k.to_s, v.to_s)
      end
      eval(undecorate(lhs)).send(dlm, eval(undecorate(rhs)))
    end

    private

    def single_delimiter?(condition)
      symbols = condition.split(' ')
      DELIMITERS.map { |d| symbols.count(d) }.sum == 1
    end

    def delimiter(condition)
      DELIMITERS.each do |d|
        return d if condition.include? d
      end
    end

    def valid_symbols?(keys, condition)
      template = condition.dup
      VALID_SYMBOLS.each { |k| template.gsub!(k, '') }
      keys.each { |k| template.gsub!(k.to_s, '') }
      template.blank?
    end

    def undecorate(condition)
      CONSTANTS_MAP.each do |k, v|
        condition.gsub!(v, k.to_s)
      end
      condition.strip
    end

    def decorate_constants(condition)
      CONSTANTS_MAP.each do |k, v|
        condition.gsub!(k.to_s, v)
      end
      condition.strip
    end
  end
end