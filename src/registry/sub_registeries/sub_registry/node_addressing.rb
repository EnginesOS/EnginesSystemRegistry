module NodeAddressing
  def is_tp_node_registered?(st, params, keys)
    st = get_type_path_node(st, params)
    if st.is_a?(Tree::TreeNode)
      is_node_registered?(st, params, keys)
    else
      false
    end
  end

  def is_ns_tp_node_registered?(st, params, keys)
    st = get_pns_type_path_node(st, params)
    if st.is_a?(Tree::TreeNode)
      is_node_registered?(st, params, keys)
    else
      false
    end
  end

  def match_nstp_path_node_keys(st, params, keys, optional = nil)
    st = get_pns_type_path_node(st, params)
    if st.is_a?(Tree::TreeNode)
      match_node_keys(st, params, keys, optional)
    else
      false
    end
  end

  def match_tp_path_node_keys(st, params, keys = nil, optional = nil)
    st = get_type_path_node(st, params)
    if st.is_a?(Tree::TreeNode)
      match_node_keys(st, params, keys, optional)
    else
      false
    end
  end

  # @returns [TreeNode] under parent_node with the Directory path (in any) in type_path convert to tree branches
  # @return nil on error
  # @param parent_node the branch to search under
  # @param type_path the dir path format as in dns or database/sql/mysql
  def get_pns_type_path_node(parent_node, type_path, publisher = nil)

    if type_path.nil? || !parent_node.is_a?(Tree::TreeNode)
      raise EnginesException.new('get_type_path_node_passed_a_nil path:' + type_path.to_s, :error, parent_node.to_s)

    end
    if type_path.is_a?(Hash)
      publisher = type_path[:publisher_namespace] if type_path.key?(:publisher_namespace)
      type_path = type_path[:type_path] if type_path.key?(:type_path)
    end
    parent_node = parent_node[publisher] unless publisher.nil?
    unless parent_node.nil?
      get_type_path_node(parent_node, type_path)
    else
      false
    end

  end

  # stn is already the branch publisher_ns,type_
  # will not resolve a type pat

  def get_type_path_node(parent_node, type_path)
    # SystemUtils.debug_output(  :get_type_path_node, type_path.to_s)
    #  STDERR.puts('get_type_path NODE' + type_path.to_s)
    type_path = type_path[:type_path] if type_path.is_a?(Hash)

    return parent_node[type_path] unless type_path.include?('/')
    sub_paths = type_path.split('/')
    sub_node = parent_node
    sub_paths.each do |sub_path|
      sub_node = sub_node[sub_path]
      break if sub_node.nil?
      #     return log_error_mesg('Subnode not found for ' + type_path + 'under node ', parent_node) if sub_node.nil?
    end
    unless sub_node.nil?
      sub_node
    else
      false
    end
  end

  # stn is already the branch publisher_ns,type_
  # will not resolve a type path
  def match_node_keys(stn, params,  required, optional = nil)
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

end