require 'rubytree'

class Registry
  attr_reader :last_error
  # handle missing persistant key as not persistance kludge to catch gui bug
  def is_persistant?(hash)
    return true if hash.key?(:persistance) && hash[:persistanct]
    return false
  end

  # returns [TreeNode] under parent_node with the Directory path (in any) in type_path convert to tree branches
  # Creates new attached [TreeNode] with required parent path if none exists
  # return nil on error
  # param parent_node the branch to create the node under
  # param type_path the dir path format as in dns or database/sql/mysql
  def create_type_path_node(parent_node, type_path)
    return log_error_mesg('create_type_path passed a nil type_path when adding to ', parent_node) if type_path.nil?
    return log_error_mesg('parent node not a tree node ', parent_node) if !parent_node.is_a?(Tree::TreeNode)
    if !type_path.include?('/')
      service_node = parent_node[type_path]
      if !service_node.is_a?(Tree::TreeNode)
        service_node = Tree::TreeNode.new(type_path, type_path)
        parent_node << service_node
      end
      return service_node
    else

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
    end
    log_error_mesg('create_type_path failed', type_path)
    return false
  end

  # @returns [TreeNode] under parent_node with the Directory path (in any) in type_path convert to tree branches
  # @return nil on error
  # @param parent_node the branch to search under
  # @param type_path the dir path format as in dns or database/sql/mysql
  def get_type_path_node(parent_node,type_path)
    if type_path.nil? || !parent_node.is_a?(Tree::TreeNode)
      log_error_mesg('get_type_path_node_passed_a_nil path:' + type_path.to_s , parent_node.to_s)
      return nil
    end
    # SystemUtils.debug_output(  :get_type_path_node, type_path.to_s)
    return parent_node[type_path]  if !type_path.include?('/')
      sub_paths = type_path.split('/')
      sub_node = parent_node
      sub_paths.each do |sub_path|
        sub_node = sub_node[sub_path]
        if sub_node.nil?
          log_error_mesg('Subnode not found for ' + type_path + 'under node ', parent_node)
          return false
        end
      end
      return sub_node
  rescue StandardError => e
    log_exception(e)
  end

  # @return [Array] of all service_hash(s) below this branch
  def get_all_leafs_service_hashes(branch)
    ret_val = []
    # SystemUtils.debug_output('top node',branch.name)
    branch.children.each do |sub_branch|
      #    SystemUtils.debug_output('on node',sub_branch.name)
      if sub_branch.children.count == 0
        ret_val.push(sub_branch.content) if sub_branch.content.is_a?(Hash)          
      else
        ret_val.concat(get_all_leafs_service_hashes(sub_branch))
      end
    end
    return order_hashes_in_priotity(ret_val)
  rescue StandardError => e
    log_exception(e)
  end

  def order_hashes_in_priotity(hashes)
    priority = []
    standard = []
    hashes.each do |service_hash|
      if !service_hash.key?(:priority) \
      || service_hash[:priority] == 0
        standard.push(service_hash)
      else
        priority.push(service_hash)
      end
    end
    return priority.concat(standard)
  end

  # @branch the [TreeNode] under which to search
  # @param label the hash key for the value to match value against
  # @return [Array] all service_hash(s) which contain the hash pair label=value
  # @return empty array if none
  def get_matched_leafs(branch, label, value)
    ret_val = []
    # SystemUtils.debug_output('top node',branch.name)
    branch.children.each do |sub_branch|
      #  SystemUtils.debug_output('sub node',sub_branch.name)
      if sub_branch.children.count == 0
        if sub_branch.content.is_a?(Hash)
          ret_val.push(sub_branch.content) if sub_branch.content[label] == value
        else
          SystemUtils.debug_output('Leaf Content not a hash ', sub_branch.content)
        end
      else # children.count > 0
        ret_val.concat(get_matched_leafs(sub_branch, label, value))
      end # if children.count == 0
    end # do
    return ret_val
  end

  # param remove [TreeNode] from the @servicetree
  # If the tree_node is the last child then the parent is removed this is continued up.
  # @return boolean
  def remove_tree_entry(tree_node)
   return log_error_mesg('remove_tree_entry Nil treenode ?', tree_node) if !tree_node.is_a?(Tree::TreeNode)
   return log_error_mesg('No Parent Node ! on remove tree entry', tree_node) if !tree_node.parent.is_a?(Tree::TreeNode)
    parent_node = tree_node.parent
    parent_node.remove!(tree_node)
    if parent_node.has_children? == false
      return log_error_mesg("failed to remove tree Entry",parent_node) if !remove_tree_entry(parent_node)
    end
    return true
  rescue StandardError => e
    log_exception(e)
    return false
  end

  def log_error_mesg(msg, object)
    obj_str = object.to_s.slice(0, 256)
    @last_error = msg + ':' + obj_str
    SystemUtils.log_error_mesg(msg, object)
    return false
  end

  def log_exception(e)
    @last_error = e.to_s.slice(0, 256)
    SystemUtils.log_exception(e)
    return false
  end
end
