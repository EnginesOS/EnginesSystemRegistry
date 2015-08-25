class SubRegistry < Registry
  def initialize(registry)
    @registry = registry
  end

  def take_snap_shot
    @snap_shot = @registry.dup
    clear_error
  end

  def roll_back
    @registry = @snap_shot if @snap_shot.nil? == false && @snap_shot.is_a?(Tree::TreeNode)
  end

  def clear_error
    @last_error = ''
  end
end
