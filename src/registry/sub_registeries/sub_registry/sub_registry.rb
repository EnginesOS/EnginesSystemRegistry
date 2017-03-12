require_relative '../../../errors/engines_registry_error.rb'

class SubRegistry < EnginesRegistryError
  require_relative '../../../errors/engines_exception.rb'
  attr_accessor :registry
  
  require_relative 'node_addressing.rb'
  include  NodeAddressing
  require_relative 'node_creation.rb'
   include  NodeCreation
  require_relative 'node_collections.rb'
  include NodeCollections
  
  def initialize(registry)
    @registry = registry
  end

  def service_provider_tree(publisher)
     @registry[publisher] if @registry.is_a?(Tree::TreeNode)
  end

  
  def is_node_registered?(st, params, keys)
    return false unless match_node_keys(st, params, keys).is_a?(Tree::TreeNode)
    true
  end

 
def is_persistent?(hash)
    return true if hash.key?(:persistent) && hash[:persistent]
    false
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
    unlock_tree
    false
  end

  def clear_error
    @last_error = ''
  end
end
