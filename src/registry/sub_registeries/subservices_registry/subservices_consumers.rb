module SubservicesConsumers


  # required[publisher_namespace,:type_path] optional [ :engine_name,:service_handle,:sub_hand]
  def find_subservice_consumers(params)
    all_registered_to(subservices_consumers, params)
  end

  # required[:publisher_namespace,:type_path :engine_name,:service_handle,:sub_hand]
  def add_to_consumers(params) 
    add_to_subservices(subservices_consumers, retrive_consumer_params(params))
  end
  # required[:publisher_namespace,:type_path :engine_name,:service_handle,:sub_hand]
  def update_attached_consumers(params)
    update_attached(subservices_consumers, retrive_consumer_params(params))
  end

  # required[:publisher_namespace,:type_path :engine_name,:service_handle,:sub_hand]
  def retrive_consumer_params(params)
    match_node_path(subservices_consumers, params)  
  end
  
  # required[:publisher_namespace,:type_path :engine_name,:service_handle,:sub_hand]
  def remove_from_consumers(params)
    stn = get_type_path_node(subservices_consumers, retrive_consumer_params(params))
  end

  # required[publisher_namespace,:type_path] optional [ :engine_name,:service_handle,:sub_hand]
  def is_consumer_registered?(params)
    is_registered?(subservices_consumers,params)
  end
  
  private
  def subservices_consumers
    @consumers ||=  create_consumers_node
  end
  def create_consumers_node
     if @registry[:consumers].nil? @consumers = Tree::TreeNode.new("Consumers")
       @registry << @consumers
     end
     @consumers
   end
end