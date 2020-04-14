class Option

  #
  # @param target - id of end_node
  # @param text - visible text
  # @param params: optional priority, action and condition
  def initialize(target, text, params = {})
    @target = target
    @text =  text
    @priority = params.fetch(:priority, 0)
    @action = params.fetch(:action, '')
    @condition = params.fetch(:condition, '')
  end

  attr_reader :text, :priority, :action, :condition
end