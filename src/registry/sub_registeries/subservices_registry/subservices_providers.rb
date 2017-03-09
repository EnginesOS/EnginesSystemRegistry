module SubservicesProviders
  # required[:publisher_namespace,:type_path ] optional [:engine_name,:service_handle]
  def subservices_registered_to_provider(params)
     all_registered_to(subservices_providers, params)
   end 
   
  # required[:publisher_namespace,:type_path ]  optional [:engine_name,:service_handle,:sub_hand]
   def is_provider_registered?(params)
     is_registered?(subservices_providers, params)
   end
 
   # required[:publisher_namespace,:type_path :engine_name,:service_handle,:sub_hand]
   def add_to_providers_registry(params)
     add_to_subservices(subservices_providers,params)
   end
 
   # required[:publisher_namespace,:type_path :engine_name,:service_handle,:sub_hand]
   def update_attached_providers(params)
     update_attached(subservices_providers,params)
   end
 
   # required[:publisher_namespace,:type_path :engine_name,:service_handle,:sub_hand]
   def remove_from_providers_registry(params)
     remove_from_registry(subservices_providers, params)    
   end
   
  def retrive_providers_params(params)
    match_node_path(subservices_providers, params)    
   end
   
   private
    
  def subservices_providers
    @providers ||=  create_providers_node
  end
   
  def create_providers_node
    if @registry[:providers].nil? @providers = Tree::TreeNode.new("Providers")
      @registry << @providers
    end
    @providers
  end
end