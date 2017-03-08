class SubservicesRegistry < SubRegistry
 
  def match_node(params, stn)
    if params.key(:engine_name)
         stn = stn[params[:engine_name]]
         return  unless stn.is_a?(Tree::TreeNode)
       end
       if params.key(:service_handle)
         stn = stn[params[:service_handle]]
         return  unless stn.is_a?(Tree::TreeNode)
       end
       if params.key(:sub_hand)
         stn = stn[params[:sub_hand]]
         return  unless stn.is_a?(Tree::TreeNode)
       end
       stn
  end
  
  # required[:publisher_namespace,:type_path] 
  def find_subservice_consumers(params)
    spt = service_provider_tree(params[:publisher_namespace])
    return [] unless spt.is_a?(Tree::TreeNode)
    stn = get_type_path_node(service_provider_tree, params[:type_path])
    return [] unless stn.is_a?(Tree::TreeNode)
    stn = match_node(params, stn)
    return [] unless stn.is_a?(Tree::TreeNode)
    get_all_leafs_service_hashes(stn)
  end

  # required[:service_name:publisher_namespace,:type_path :engine_name,:service_handle,:sub_hand]
  def all_subservices_registered_to(params)
    st = service_provider_tree(params[:publisher_namespace])    
      return [] unless st.is_a?(Tree::TreeNode)   
   st = match_node(params, st)
    return [] unless st.is_a?(Tree::TreeNode)
    get_all_leafs_service_hashes(st)
  end

#  def get_subservices_registered_against_service(params)
#  end

  def get_subservice_entry(params)
  end
  
  # required[:service_name:publisher_namespace,:type_path :engine_name,:service_handle,:sub_hand]
  def subservice_is_registered?(params)
    st = service_provider_tree(params[:publisher_namespace])       
       return false unless st.is_a?(Tree::TreeNode)   
       st = match_node(params, st)
        return false unless st.is_a?(Tree::TreeNode)
        true
  end

  def add_to_subservices_registry(params)
    

  end

  def update_attached_subservice(params)
    
    
  end

  def remove_from_subservices_registry()
    
    
  end

end
