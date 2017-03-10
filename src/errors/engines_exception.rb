class EnginesException <  StandardError
  attr_reader :level, :params
  def initialize(msg="Engines Exception", level=:error, *params)
      @level = level
      @params = params
      super(msg)
    end
end