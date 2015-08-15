class SubRegistry < Registry
  
  def initialize(registry)
     @registry = registry
   end   
  def take_snap_shot
    @snap_shot= @registry.dup
    clear_error
  end
  def roll_back
     if @snap_shot.is_a?(Tree::TreeNode)      
        @registry = @snap_shot
     end
  end
  def clear_error
    @last_error=""
  end
end