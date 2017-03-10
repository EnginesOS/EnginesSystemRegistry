class SubRegistry < Registry

  attr_accessor :registry
  def initialize(registry)
    @registry = registry
  end

  def service_provider_tree(publisher)
    return @registry[publisher] if @registry.is_a?(Tree::TreeNode)
  end

  def match_nstp_path_node_keys(st, params, keys, optional = nil)
    st = get_type_path_node(st, params)
    return unless st.is_a?(Tree::TreeNode)
    match_node_keys(st, params, keys, optional)
  end

  # stn is already the branch publisher_ns,type_
  # will not resolve a type path
  def add_to_tree_path(tree_node, params, address_keys, unique = nil)
    address_keys.each do |address_key|
      new_node = tree_node[params[address_key]]
      unless new_node.is_a?(Tree::TreeNode)
        new_node = Tree::TreeNode.new( service_hash[address_key] )
        tree_node << new_node
      end
      tree_node = new_node
    end
    unless unique.nil?
      raise EnginesException('Existing entry already exists ',:error, address_keys) if tree_node.key?(unique)
      new_node = Tree::TreeNode.new( unique )
    end
    new_node.content = params
    tree_node << new_node
    true
  end

  # stn is already the branch publisher_ns,type_
  # will not resolve a type path
  def match_node_keys(stn, params,  required, optional = nil)
    r = ''
    unless required.nil?
      required.each do |match|
        raise EnginesException('Require key missing ',:error, match) unless params.key?(match)
        stn = stn[params[match]]
        return unless stn.is_a?(Tree::TreeNode)
      end
    end
    unless optional.nil?
      optional.each do |match|
        return stn unless params.key?(match)
        stn = stn[params[match]]
        return unless stn.is_a?(Tree::TreeNode)
      end
    end
    stn
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
