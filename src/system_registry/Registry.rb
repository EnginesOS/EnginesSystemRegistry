require 'rubytree'
class Registry
  attr_reader :last_error
  #  # returns [TreeNode] under parent_node with the Directory path (in any) in type_path convert to tree branches
  #   # Creates new attached [TreeNode] with required parent path if none exists
  #   # return nil on error
  #   #param parent_node the branch to create the node under
  #   #param type_path the dir path format as in dns or database/sql/mysql
     def create_type_path_node(parent_node,type_path)
       if type_path == nil
         log_error_mesg("create_type_path passed a nil type_path when adding to ",parent_node)
         return false
       end
       if parent_node.is_a?(Tree::TreeNode) == false
         log_error_mesg("parent node not a tree node ",parent_node)
               return false
             end
       if type_path.include?("/") == false
         service_node = parent_node[type_path]
         if service_node == nil
           service_node = Tree::TreeNode.new(type_path,type_path)
           parent_node << service_node
         end
         return service_node
       else
   
         sub_paths= type_path.split("/")
         prior_node = parent_node
         count=0
   
         sub_paths.each do |sub_path|
           sub_node = prior_node[sub_path]
           if sub_node == nil
             sub_node = Tree::TreeNode.new(sub_path,sub_path)
             prior_node << sub_node
           end
           prior_node = sub_node
           count+=1
           if count == sub_paths.count
             return sub_node
           end
         end
       end
       log_error_mesg("create_type_path failed",type_path)
       return false
     end
    
  #@returns [TreeNode] under parent_node with the Directory path (in any) in type_path convert to tree branches
   #@return nil on error
   #@param parent_node the branch to search under
   #@param type_path the dir path format as in dns or database/sql/mysql
   def get_type_path_node(parent_node,type_path)
     if type_path == nil || parent_node.is_a?(Tree::TreeNode) == false
       log_error_mesg("get_type_path_node_passed_a_nil path:" + type_path.to_s , parent_node.to_s)
       return nil
     end
    # SystemUtils.debug_output(  :get_type_path_node, type_path.to_s)
     if type_path.include?("/") == false
       return parent_node[type_path]
  
     else
       sub_paths= type_path.split("/")
       sub_node = parent_node
       sub_paths.each do |sub_path|
         sub_node = sub_node[sub_path]
         if sub_node == nil
           log_error_mesg("Subnode not found for " + type_path + "under node ", parent_node)
           return false
         end
       end
       return sub_node
     end
  rescue Exception=>e
       log_exception(e)
       return false
     
   end
  # @return [Array] of all service_hash(s) below this branch
     def get_all_leafs_service_hashes(branch)
       ret_val = Array.new
       #SystemUtils.debug_output("top node",branch.name)
       branch.children.each do |sub_branch|
     #    SystemUtils.debug_output("on node",sub_branch.name)
         if sub_branch.children.count == 0
           if sub_branch.content.is_a?(Hash)
            
             #SystemUtils.debug_output("pushed_content", sub_branch.content)
             ret_val.push(sub_branch.content)
           else
             SystemUtils.debug_output("skipping content ", sub_branch.content)
           end
         else
           ret_val.concat(get_all_leafs_service_hashes(sub_branch))
         end
       end
       return ret_val
       rescue Exception=>e
            log_exception(e)
            return nil
     end
   #@branch the [TreeNode] under which to search
     #@param label the hash key for the value to match value against
     #@return [Array] all service_hash(s) which contain the hash pair label=value    
     #@return empty array if none
     def get_matched_leafs(branch,label,value)
       ret_val = Array.new
      # SystemUtils.debug_output("top node",branch.name)
       branch.children.each do |sub_branch|
      #   SystemUtils.debug_output("sub node",sub_branch.name)
         if sub_branch.children.count == 0
           if sub_branch.content.is_a?(Hash) 
             if  sub_branch.content[label] == value
               ret_val.push(sub_branch.content)   
             end
           else
            SystemUtils.debug_output("Leaf Content not a hash ",sub_branch.content)
              end
         else #children.count > 0
           ret_val.concat(get_matched_leafs(sub_branch,label,value))
         end #if children.count == 0
       end #do
       return ret_val
     end
     
# param remove [TreeNode] from the @servicetree
  # If the tree_node is the last child then the parent is removed this is continued up.
  #@return boolean  
  def remove_tree_entry(tree_node)

   
    if   tree_node.is_a?(Tree::TreeNode ) == false
      log_error_mesg("Nil treenode ?",tree_node)      
      return false
    end

    if tree_node.parent.is_a?(Tree::TreeNode) == false
      log_error_mesg("No Parent Node ! on remove tree entry",tree_node)
      return false
    end

    parent_node = tree_node.parent
    parent_node.remove!(tree_node)
    if parent_node.has_children? == false
      remove_tree_entry(parent_node)
    end

    return true
    rescue Exception=>e
         log_exception(e)
         return false
  end
def log_error_mesg(msg,object)
   obj_str = object.to_s.slice(0,256)

   @last_error = msg +":" + obj_str
   SystemUtils.log_error_mesg(msg,object)

 end

 def log_exception(e)
   @last_error = e.to_s.slice(0,256)
   SystemUtils.log_exception(e)
 end
  
end