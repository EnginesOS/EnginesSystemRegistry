class SubRegistry < Registry
  require_relative '../../errors/engines_exception.rb'
  attr_accessor :registry
  def initialize(registry)
    @registry = registry
  end

  def service_provider_tree(publisher)
    return @registry[publisher] if @registry.is_a?(Tree::TreeNode)
  end

  def is_ns_tp_node_registered?(st, params, keys)
    st = get_type_path_node(st, params)
    return false unless st.is_a?(Tree::TreeNode)
    is_node_registered?(st, params, keys)
  end
  
def is_node_registered?(st, params, keys)
    return false unless match_node_keys(st, params, keys).is_a?(Tree::TreeNode)
    true
  end
  
  def match_nstp_path_node_keys(st, params, keys, optional = nil)
    st = get_type_path_node(st, params)
    return unless st.is_a?(Tree::TreeNode)
    match_node_keys(st, params, keys, optional)
  end

  def add_to_ns_tp_tree_path(tn, params, address_keys, unique = nil)
    tree_node = get_type_path_node(tn, params)
    add_to_tree_path(tree_node, params, address_keys, unique )
  end

  # stn is already the branch publisher_ns,type_
  # will not resolve a type path
  def add_to_tree_path(tree_node, params, address_keys, unique = nil)
    address_keys.each do |address_key|
      new_node = tree_node[params[address_key]]
      unless new_node.is_a?(Tree::TreeNode)
        new_node = Tree::TreeNode.new(params[address_key])
        tree_node << new_node
      end
      tree_node = new_node
    end
    unless unique.nil?
      STDERR.puts('Existing entry already exists ' + unique.to_s + ' ' + :error.to_s  + ':' + address_keys.to_s) unless tree_node[unique].nil?
      raise EnginesException.new('Existing entry already exists ' + unique ,:error, address_keys) unless tree_node[unique].nil?
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
        STDERR.puts('Required key missing ' + match.to_s + :error.to_s + ':'  +  params.to_s) unless params.key?(match)
        raise EnginesException.new('Required key missing ' + match.to_s ,:error, params) unless params.key?(match)
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
    unlock_tree
    false
  end

  def clear_error
    @last_error = ''
  end
end
