class SubRegistry < Registry
  require_relative '../../errors/engines_exception.rb'
  attr_accessor :registry
  def initialize(registry)
    @registry = registry
  end

  def service_provider_tree(publisher)
    return @registry[publisher] if @registry.is_a?(Tree::TreeNode)
  end

  def is_tp_node_registered?(st, params, keys)
    st = get type_path_node(st, params)
    return false unless st.is_a?(Tree::TreeNode)
    is_node_registered?(st, params, keys)
  end

  def is_node_registered?(st, params, keys)
    return false unless match_node_keys(st, params, keys).is_a?(Tree::TreeNode)
    true
  end

  def match_nstp_path_node_keys(st, params, keys, optional = nil)
    st = get_pns_type_path_node(st, params)
    return unless st.is_a?(Tree::TreeNode)
    match_node_keys(st, params, keys, optional)
  end

  def match_tp_path_node_keys(st, params, keys, optional = nil)
    st = get_type_path_node(st, params)
    STDERR.puts('get_type_path_node passws:' + s.to_s, + ' ' + keys.to_s + ' ' + optional.to_s)
    return unless st.is_a?(Tree::TreeNode)
    STDERR.puts('get_type_path_node:' + pe.to_s)
    match_node_keys(st, params, keys, optional)
  end

  def add_to_ns_tp_tree_path(tn, params, address_keys, node_name ,unique = true)
    tree_node = create_type_path_node(tn, params)
    add_to_tree_path(tree_node, params, address_keys, node_name ,unique )
  end

  # stn is already the branch publisher_ns,type_
  # will not resolve a type pat
  def add_to_tree_path(tree_node, params, address_keys, node_name , unique = true)
    address_keys.each do |address_key|
      new_node = tree_node[params[address_key]]
      unless new_node.is_a?(Tree::TreeNode)
        new_node = Tree::TreeNode.new(params[address_key])
        #       STDERR.puts('creating node' + params[address_key])
        tree_node << new_node
      end
      tree_node = new_node
    end
    #STDERR.puts('Procedding to entry ' + node_name.to_s )
    new_node = tree_node[node_name]
    if new_node.is_a?(Tree::TreeNode)
      #   STDERR.puts('Existing entry already exists ' + node_name.to_s + ' ' + :error.to_s  + ':' + address_keys.to_s)
      raise EnginesException.new('Existing entry already exists ' + node_name.to_s ,:error, address_keys) if unique == true
    else
      new_node = Tree::TreeNode.new( node_name )
      #    STDERR.puts('creating leaf' + node_name)
      tree_node << new_node
    end
    #STDERR.puts('set content ' + params.to_s )
    new_node.content = params
    true
  end

  # stn is already the branch publisher_ns,type_
  # will not resolve a type path
  def match_node_keys(stn, params,  required, optional = nil)
    r = ''
    unless required.nil?
      required.each do |match|
        #  STDERR.puts('Required key missing ' + match.to_s + :error.to_s + ':'  +  params.to_s) unless params.key?(match)
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
