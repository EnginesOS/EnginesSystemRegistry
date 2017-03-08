class SubRegistry < Registry

  attr_accessor :registry
  def initialize(registry)
    @registry = registry
  end

  
    def service_provider_tree(publisher)
      return @registry[publisher] if @registry.is_a?(Tree::TreeNode)    
    end
  
  
  
  
  def reset_registry(registry)
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
