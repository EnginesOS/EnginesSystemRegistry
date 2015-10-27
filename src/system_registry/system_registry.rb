require_relative 'registry.rb'
require 'yaml'
require 'fileutils'

class SystemRegistry < Registry
  @@service_tree_file = '/opt/engines/run/service_manager/services.yaml'   
  
  @@RegistryLock='/tmp/registry.lock'
  require_relative 'sub_registry.rb'
  require_relative 'configurations_registry.rb'
  require_relative 'managed_engines_registry.rb'
  require_relative 'services_registry.rb'
  require_relative 'orphan_services_registry.rb'
  require_relative 'system_utils.rb'
  # @ call initialise Service Registry Tree which loads it from disk or create a new one if none exits
  def initialize
    # @service_tree root of the Service Registry Tree
    @system_registry = initialize_tree
    @configuration_registry = ConfigurationsRegistry.new(service_configurations_registry_tree)
    @services_registry = ServicesRegistry.new(services_registry_tree_tree)
    @managed_engines_registry = ManagedEnginesRegistry.new(managed_engines_registry_tree)
    @orphan_server_registry = OrphanServicesRegistry.new(orphaned_services_registry_tree)
  end

  def update_attached_service(service_hash)
    take_snap_shot
    if test_services_registry_result(@services_registry.remove_from_services_registry(service_hash)) &&
    test_services_registry_result(@managed_engines_registry.remove_from_engine_registry(service_hash)) &&
    test_engines_registry_result(@managed_engines_registry.add_to_managed_engines_registry(service_hash)) &&
    test_engines_registry_result(@services_registry.add_to_services_registry(service_hash))
      return save_tree
    end
    roll_back
    return false
  end
  
  
  def shutdown
     p :GOT_SHUT_DOWN
    roll_back
  
   end
   
  def find_service_consumers(service_query_hash)
    clear_error
    test_services_registry_result(@services_registry.find_service_consumers(service_query_hash))
  end



  def add_to_services_registry(service_hash)
    take_snap_shot
    return save_tree if test_services_registry_result(@services_registry.add_to_services_registry(service_hash))
    roll_back
    return false
  end

  def remove_from_services_registry(service_hash)
    take_snap_shot
    return save_tree if test_services_registry_result(@services_registry.remove_from_services_registry(service_hash))
    roll_back
    return false
  end

  # @return an [Array] of service_hashes regsitered against the Service params[:publisher_namespace] params[:type_path]
  def get_registered_against_service(params)
    clear_error
    test_services_registry_result(@services_registry.get_registered_against_service(params))
  end

  def list_providers_in_use
    clear_error
    test_services_registry_result(@services_registry.list_providers_in_use)
  end

  def service_is_registered?(service_hash)
    clear_error
    test_services_registry_result(@services_registry.service_is_registered?(service_hash))
  end

  #  def  find_engine_services_hashes(params)
  #    clear_error
  #    test_engines_registry_result(@managed_engines_registry.find_engine_services_hashes(params))
  #  end

  # ENGINE STUFF

  def find_engine_services_hashes(params)
    clear_error
    test_engines_registry_result(@managed_engines_registry.find_engine_services_hashes(params))
  end
  # Returns Treenodes
  #  def find_engine_services(params)
  #    clear_error
  #    test_engines_registry_result(@managed_engines_registry.find_engine_services(params))
  #  end

  def find_engine_service_hash(params)
    clear_error
    test_engines_registry_result(@managed_engines_registry.find_engine_service_hash(params))
  end

#  def  get_active_persistant_services(params)
#    clear_error
#    test_engines_registry_result(@managed_engines_registry.get_active_persistant_services(params, false))
#  end
  
  def get_engine_nonpersistant_services(params)
    clear_error
    test_engines_registry_result(@managed_engines_registry.get_engine_persistance_services(params, false))
  end

  def get_engine_persistant_services(params)
    clear_error
    test_engines_registry_result(@managed_engines_registry.get_engine_persistance_services(params, true))
  end

  def remove_from_managed_engines_registry(service_hash)
    take_snap_shot
    return save_tree if test_engines_registry_result(@managed_engines_registry.remove_from_engine_registry(service_hash))
    roll_back
    return false
  end

  def all_engines_registered_to(service_path)
    clear_error
    test_engines_registry_result(@managed_engines_registry.all_engines_registered_to(service_path))
  end

  def add_to_managed_engines_registry(service_hash)
    take_snap_shot
    return save_tree if test_engines_registry_result(@managed_engines_registry.add_to_managed_engines_registry(service_hash))
    roll_back
    return false
  end

  # @return boolean true if not nil
  def check_system_registry_tree
    clear_error
    st = system_registry_tree
    return SystemUtils.log_error_mesg('Nil service tree ?', st) if !st.is_a?(Tree::TreeNode)
    return true
  rescue StandardError => e
    log_exception(e)
  end

  def system_registry_tree    

    current_mod_time = File.mtime(@@service_tree_file) unless @last_tree_mod_time == nil 
   # @last_tree_mod_time = nil
      if @last_tree_mod_time.nil? || !@last_tree_mod_time.eql?(current_mod_time)
        @system_registry = load_tree
        set_registries
      end
    return @system_registry
  rescue StandardError => e
    log_exception(e)
    return false
  end
  
  def sync
    p :SYNC
    system_registry_tree    
  end

  # @return the ManagedServices Tree [TreeNode] Branch
  #  creates if does not exist
  def services_registry_tree
    clear_error
    return false if !check_system_registry_tree
    system_registry_tree << Tree::TreeNode.new('Services', 'Service register') if !system_registry_tree['Services'].is_a?(Tree::TreeNode)
    return system_registry_tree['Services']
  rescue StandardError => e
    log_exception(e)
    return false
  end



  # @return the ManagedEngine Tree Branch
  # creates if does not exist
  def managed_engines_registry_tree
    clear_error
    return false if !check_system_registry_tree
    system_registry_tree << Tree::TreeNode.new('ManagedEngine', 'ManagedEngine Service register') if !system_registry_tree['ManagedEngine'].is_a?(Tree::TreeNode)
    system_registry_tree['ManagedEngine']
  rescue StandardError => e
    log_exception(e)
  end

  
  def orphaned_services_registry_tree
    clear_error
    return false if !check_system_registry_tree
    orphans = system_registry_tree['OphanedServices']
    system_registry_tree << Tree::TreeNode.new('OphanedServices', 'Persistant Services left after Engine Deinstall') if !orphans.is_a?(Tree::TreeNode)
    system_registry_tree['OphanedServices']
  rescue StandardError => e
    log_exception(e)
    return nil
  end

  # @params [Hash] Loads the varaibles from the matching orphan
  # does not save bnut just populates the content/service variables in the hash
  # return boolean
  def reparent_orphan(params)
    clear_error
    test_orphans_registry_result(@orphan_server_registry.reparent_orphan(params))
  end

  # @params [Hash] of orphan matching the params
  # return boolean
  def retrieve_orphan(params)
    clear_error
    test_orphans_registry_result(@orphan_server_registry.retrieve_orphan(params))
  end

  # Removes orphan and places in the managed_engine_registry
  def rebirth_orphan(params)
    take_snap_shot
    if test_orphans_registry_result(@orphan_server_registry.release_orphan(params))
      if test_services_registry_result(@services_registry.add_to_services_registry(params))
        return save_tree if test_services_registry_result(@managed_engines_registry.add_to_managed_engines_registry(params))
      end
    end
    roll_back
  end

  def release_orphan(params)
    take_snap_shot
    return save_tree if test_orphans_registry_result(@orphan_server_registry.release_orphan(params))
    roll_back
    return false
  end

  def get_orphaned_services(params)
    clear_error
    test_orphans_registry_result(@orphan_server_registry.get_orphaned_services(params))
  end
  #
  #  def find_orphan_consumers(params)
  #    clear_error
  #    test_orphans_registry_result(@orphan_server_registry.find_orphan_consumers(params))
  #  end

  def orphanate_service(service_hash)
    take_snap_shot
    #    service_hash = test_orphans_registry_result(@orphan_server_registry.retrieve_orphan(service_query_hash))
    #    if service_hash == nil
    #      log_error_mesg(@orphan_server_registry.last_error.to_s)
    #      return false
    #    end
    p :oprhanicate_now
    if test_orphans_registry_result( @orphan_server_registry.orphanate_service(service_hash))
      if test_services_registry_result(@services_registry.remove_from_services_registry(service_hash))
        return save_tree
      else
        @orphan_server_registry.release_orphan(service_hash)
        log_error_mesg('Failed to save orphan in remove_from_services_registry' + @services_registry.last_error.to_s, service_hash)
      end
      log_error_mesg('Failed to save orphan' + @orphan_server_registry.last_error.to_s, service_hash)
    end
    roll_back
    return false
  end

 
  
  def service_configurations_registry_tree
    clear_error
    return false if !check_system_registry_tree
    system_registry_tree << Tree::TreeNode.new('Configurations', 'Service Configurations') if system_registry_tree['Configurations'].nil?
    system_registry_tree['Configurations']
  rescue StandardError => e
    log_exception(e)
    return nil
  end
  
  def get_service_configurations_hashes(service_hash)
      clear_error
      test_configurations_registry_result(@configuration_registry.get_service_configurations_hashes(service_hash))
    end
    
    def add_service_configuration(service_hash)
      take_snap_shot
      return save_tree if test_configurations_registry_result(@configuration_registry.add_service_configuration(service_hash))
      roll_back  
     end
     
    def rm_service_configuration(service_hash)
      take_snap_shot
      return save_tree if test_configurations_registry_result(@configuration_registry.rm_service_configuration(service_hash))
      roll_back 
      end
     
     def get_service_configuration(service_hash)
        clear_error
        test_configurations_registry_result(@configuration_registry.get_service_configuration(service_hash))
     end
    
    def update_service_configuration(config_hash)
      take_snap_shot
      return save_tree if test_configurations_registry_result(@configuration_registry.update_service_configuration(config_hash))
      roll_back
      return false
    end
  
  

  private

  def get_service_entry(service_query_hash)
    clear_error
    tree_node = find_service_consumers(service_query_hash)
    return false  if !tree_node.is_a?(Tree::TreeNode)
    return tree_node.content
  end
    
  def test_orphans_registry_result(result)
     @last_error = @last_error.to_s + ':' + @orphan_server_registry.last_error.to_s  if result.is_a?(FalseClass)
     return result
   end
 
   def test_engines_registry_result(result)
     @last_error = @last_error.to_s + ':' + @managed_engines_registry.last_error.to_s if result.is_a?(FalseClass)
     return result
   end
 
   def test_services_registry_result(result)
     @last_error = @last_error.to_s + ':' + @services_registry.last_error.to_s if result.is_a?(FalseClass)
     return result
   end
 
   def test_configurations_registry_result(result)
     @last_error = @last_error.to_s + ':' + @configuration_registry.last_error.to_s if result.is_a?(FalseClass)
     return result
   end

  def take_snap_shot
    lock_tree
    @configuration_registry.take_snap_shot
    @services_registry.take_snap_shot
    @managed_engines_registry.take_snap_shot
    @orphan_server_registry.take_snap_shot
    clear_error
  end

  def clear_error
    @last_error = ''
  end

  def roll_back
    p ':++++++++++++++++++++++++++++++++++'
    p ':____________ROLL_BACK_____________:'
    p '++++++++++++++++++++++++++++++++++'
    #
    #    if @snap_shot.is_a?(Tree::TreeNode)
    #      @system_registry = @snap_shot
    #    end
    #perhaps just reload
#    @configuration_registry.roll_back
#    @system_registry ['Configurations'] = @configuration_registry.registry
#    
#    @services_registry.roll_back
#    @system_registry['Services'] = @services_registry.registry
#      
#    @managed_engines_registry.roll_back
#    @system_registry['ManagedEngine'] = @managed_engines_registry.registry
#    
#    @orphan_server_registry.roll_back
#    @system_registry['OphanedServices'] = @orphan_server_registry.registry
    
  #  unlock_tree unlock occurs in load tree
    @system_registry = load_tree
    set_registries
    return @system_registry
  rescue StandardError => e
    log_exception(e)
  end
  
  def set_registries
    @configuration_registry.reset_registry(@system_registry['Configurations'])
    @orphan_server_registry.reset_registry(@system_registry['OphanedServices'])
    @managed_engines_registry.reset_registry(@system_registry['ManagedEngine'])
    @services_registry.reset_registry(@system_registry['Services'])
      
  end

  # loads the Service tree off disk from [SysConfig.ServiceTreeFile]
  # calls [log_exception] on error and returns nil
  # @return service_tree [TreeNode]
  def tree_from_yaml
    clear_error
    begin      
      if File.exist?(@@service_tree_file)
        tree_data = File.read(@@service_tree_file)
      elsif File.exist?(@@service_tree_file + '.bak')
        tree_data = File.read(@@service_tree_file + '.bak')
      end
      registry = YAML::load(tree_data)
      return registry
    rescue StandardError => e
      puts e.message + ' with ' + tree_data.to_s
      log_exception(e)
      return nil
    end
  end

  # Load tree from file or create initial service tree
  # @return ServiceTree as a [TreeNode]
  def initialize_tree
    return load_tree if File.exist?(@@service_tree_file)    
    lock_tree
    @system_registry = Tree::TreeNode.new('Service Manager', 'Managed Services and Engines')
    @system_registry << Tree::TreeNode.new('ManagedEngine', 'Engines')
    @system_registry << Tree::TreeNode.new('Services', 'Managed Services')
    save_tree
    @system_registry 
  rescue StandardError => e
    puts e.message
    log_exception(e)
  end

  def lock_tree
    if File.exist?(@@RegistryLock)
      sleep 1
      sleep 1 if File.exist?(@@RegistryLock)
      p :REGISTRY_LOCKED
      return log_error_mesg("Failed to lock",@@RegistryLock) if File.exist?(@@RegistryLock)
    end
    FileUtils.touch(@@RegistryLock)
    return true
  end
  
  def unlock_tree
    File.delete(@@RegistryLock)
  end
  
    # @sets the service_tree and load mod time
  def load_tree
    clear_error
  unless lock_tree
    p :Failed_to_gain_lock   
    return nil 
  end
    registry = tree_from_yaml()
    p :LOAD_TREE
    @last_tree_mod_time = nil
    @last_tree_mod_time = File.mtime(@@service_tree_file) if File.exist?(@@service_tree_file)
    unlock_tree
    return registry
  rescue StandardError => e
    @last_error = 'load tree'
    log_exception(e)
    return false
  end

  # saves the Service tree to disk at [SysConfig.ServiceTreeFile] and returns tree
  # calls [log_exception] on error and returns false
  # @return boolean
  def save_tree
    clear_error    
    p :save_trer
    FileUtils.copy(@@service_tree_file, @@service_tree_file + '.bak') if File.exist?(@@service_tree_file)

    serialized_object = YAML::dump(@system_registry)
    f = File.new(@@service_tree_file + '.tmp', File::CREAT | File::TRUNC | File::RDWR, 0644)
    f.puts(serialized_object)
    f.close    
    FileUtils.mv(@@service_tree_file + '.tmp', @@service_tree_file)
    @last_tree_mod_time = File.mtime(@@service_tree_file)
    unlock_tree
    return true
  rescue StandardError => e
    @last_error = 'save error'
    FileUtils.copy(@@service_tree_file + '.bak', @@service_tree_file) if !File.exist?(@@service_tree_file)
    log_exception(e)
  end
end
