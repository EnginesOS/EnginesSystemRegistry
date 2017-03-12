module NodeCollections
  
  # @return [Array] of all service_hash(s) below this branch
  def get_all_leafs_service_hashes(branch)
    return if branch.nil?
    if branch.children.count == 0
      return branch.content if branch.content.is_a?(Hash)
      return
    end
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
    order_hashes_in_priotity(ret_val)
  rescue StandardError => e
    log_exception(e)
  end
  def order_hashes_in_priotity(hashes)
      return hashes unless hashes.is_a?(Array)
      priority = []
      standard = []
      service_hash = nil
      hashes.each do |service_hash|
        if !service_hash.key?(:priority) \
        || service_hash[:priority] == 0
          standard.push(service_hash)
        else
          priority.push(service_hash)
        end
      end
      priority.concat(standard)
    rescue StandardError => e
      p :exception
      p service_hash
      p hashes
      log_exception(e)
    end
    
  
  # @branch the [TreeNode] under which to search
  # @param label the hash key for the value to match value against
  # @return [Array] all service_hash(s) which contain the hash pair label=value
  # @return empty array if none
  def get_matched_leafs(branch, label, value)
    return if branch.nil?
    return if branch.children.count == 0
    ret_val = []
    branch.children.each do |sub_branch|
      if sub_branch.children.count == 0
        if sub_branch.content.is_a?(Hash)
          ret_val.push(sub_branch.content) if sub_branch.content[label] == value
        else
        raise EnginesException.new('Leaf Content not a hash ', :error, sub_branch.content)
        end
      else # children.count > 0
        ret_val.concat(get_matched_leafs(sub_branch, label, value))
      end # if children.count == 0
    end # do
    ret_val
  end
end