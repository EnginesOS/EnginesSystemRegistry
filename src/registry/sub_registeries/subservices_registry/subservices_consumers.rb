module SubservicesConsumers
  # required[:service_name] optional [ :engine_name,:service_handle,:sub_handle]
  def all_subservices_registered_to(params)
    all_registered_to(subservices_consumers, params)
  end

  # required[:service_name :engine_name,:service_handle,:sub_handle]
  def add_to_subservices_registry(params)
    STDERR.puts("\ndef add_to_subservices(spt,params" + params.to_s)
    add_to_subservices(subservices_consumers, params)
  end

  # required[:service_name :engine_name,:service_handle,:sub_handle]
  def update_attached_subservice(params)
    update_attached(subservices_consumers, params)
  end

  # required[:service_name :engine_name,:service_handle,:sub_handle]
  def get_subservice_entry(params)
    match_node_keys(subservices_consumers, params)
  end

  # required[:service_name :engine_name,:service_handle,:sub_handle]
  def remove_from_subservices_registry(params)
    remove_from_registry(subservices_consumers, params)
  end

  # required[:service_name] optional [ :engine_name,:service_handle,:sub_handle]
  def subservice_is_registered?(params)
    is_registered?(subservices_consumers ,params)
  end

  private

  def subservices_consumers
    @consumers ||=  create_consumers_node
  end

  def create_consumers_node
    if @registry[:consumers].nil? 
      @consumers = Tree::TreeNode.new("Consumers")
      @registry << @consumers
    end
    @consumers
  end
end