module NodeCreation
  def add_to_tp_tree_path(tn, params, address, node_name ,unique = true)
    tree_node = create_type_path_node(tn, address)
    add_to_tree_path(tree_node, params, nil, node_name ,unique )
  end

  def add_to_ns_tp_tree_path(tn, params, address_keys, node_name ,unique = true)
    tree_node = create_ns_type_path_node(tn, params)
    add_to_tree_path(tree_node, params, address_keys, node_name ,unique )
  end

  def create_ns_type_path_node(parent_node, params)
    p = parent_node[params[:publisher_namespace]]
    unless p.is_a?(Tree::TreeNode)
      p = Tree::TreeNode.new(params[:publisher_namespace], 'Publisher:' + params[:publisher_namespace] )
      parent_node << p
    end
    create_type_path_node(p, params)
  end

def add_to_tree_path(tree_node, params, address_keys, node_name , unique = true)
  unless address_keys.nil?
    address_keys.each do |address_key|
      new_node = tree_node[params[address_key]]
      unless new_node.is_a?(Tree::TreeNode)
        new_node = Tree::TreeNode.new(params[address_key])
        tree_node << new_node
      end
      tree_node = new_node
    end
  end
  new_node = tree_node[node_name]
unique = !params[:overwrite] if params.key?(:overwrite)
  if new_node.is_a?(Tree::TreeNode)
    raise EnginesException.new('Existing entry already exists ' + node_name.to_s ,:error, address_keys) if unique == true
  else
    new_node = Tree::TreeNode.new( node_name )
    tree_node << new_node
  end
if params.key?(:overwrite)
  new_node.content[:variables] = params[:variables]
else
  new_node.content = params
end
  true
end
  # returns [TreeNode] under parent_node with the Directory path (in any) in type_path convert to tree branches
  # Creates new attached [TreeNode] with required parent path if none exists
  # return nil on error
  # param parent_node the branch to create the node under
  # param type_path the dir path format as in dns or database/sql/mysql
  def create_type_path_node(parent_node, address)
    raise EnginesException.new('create_type_path passed a nil', :error, parent_node) if address.nil?
    raise EnginesException.new('parent node not a tree node ', :error, parent_node) unless parent_node.is_a?(Tree::TreeNode)
    if address.is_a?(Hash)
      type_path = address[:type_path]
    else
      type_path = address
    end

    if type_path.include?('/')
      sub_paths = type_path.split('/')
      prior_node = parent_node
      count = 0
      sub_paths.each do |sub_path|
        sub_node = prior_node[sub_path]
        if sub_node.nil?
          sub_node = Tree::TreeNode.new(sub_path, sub_path)
          prior_node << sub_node
        end
        prior_node = sub_node
        count += 1
        return sub_node if count == sub_paths.count
      end
    else
      service_node = parent_node[type_path]
      unless service_node.is_a?(Tree::TreeNode)
        service_node = Tree::TreeNode.new(type_path, type_path)
        parent_node << service_node
      end
      return service_node
    end
    raise EnginesException.new('create_type_path failed', :error, type_path)
  end

  # param remove [TreeNode] from the @servicetree
  # If the tree_node is the last child then the parent is removed this is continued up.
  # @return boolean
  def remove_tree_entry(tree_node)
    raise EnginesException.new('Femove tree entry Nil treenode ?', :error, tree_node) unless tree_node.is_a?(Tree::TreeNode)
    raise EnginesException.new('No Parent Node on remove tree entry', :error, tree_node) unless tree_node.parent.is_a?(Tree::TreeNode)
    raise EnginesException.new("Not removing a branch", :error, tree_node) if tree_node.has_children?
    parent_node = tree_node.parent
    parent_node.remove!(tree_node)
    unless parent_node.has_children?
      raise EnginesException.new("Failed to remove tree Entry", :error, parent_node) unless remove_tree_entry(parent_node)
    end
    true

  end
end