module QuestEngine
  class ActionParser
    require 'lexeme'


    CONSTANTS = %w[true false].freeze
    OPERATORS = %w[+ -].freeze
    VALID_SYMBOLS = CONSTANTS + OPERATORS
    CONSTANTS_MAP = {'true': '#', 'false': '$'}.freeze

    def initialize
      @lexer = Lexeme.define do
        token :EQ       => /^=$/
        token :PLUS     => /^\+$/
        token :MINUS    => /^\-$/
        token :MULT    => /^\*$/
        token :DIV      => /^\/$/
        token :NUMBER   => /^\d+\.?\d?$/
        token :RESERVED => /^(true|false|\$)$/
        token :STRING   => /^".*"$/
        token :ID       => /^[\w_"]+$/
      end
    end

    def valid_action?(keys, action)
      singles = split_action action
      key_strings = keys.map(&:to_s)
      singles.map{ |s| valid_single? key_strings, s }.all?
    end

    def perform(state, action)
      split_action(action).each{ |x| perform_single(state, x)}
    end

    private

    def perform_single(state, single)
      lhs, rhs = single.split('=').map(&:strip)
      state.sort_by{ |k, _| k.to_s.length}.reverse.each { |k, v| rhs.gsub!(k.to_s, v.to_s)}
      state[lhs.to_sym] = eval(rhs)
    end

    def split_action(action)
      action.split("\n");
    end

    def valid_single?(keys, single)
      lhs, rhs = single.split('=').map(&:strip)
      keys.map(&:to_s).include?(lhs) && valid_rhs?(keys, rhs)
    end

    def valid_rhs?(keys, rhs)
      tokens = @lexer.analyze do
        from_string rhs
      end
      tokens.filter{ |x| x.name == :ID}.all? { |x| keys.include? x.value}
    end
  end
end
