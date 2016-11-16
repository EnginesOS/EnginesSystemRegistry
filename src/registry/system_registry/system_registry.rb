require_relative '../registry.rb'
require 'yaml'
require 'fileutils'

class SystemRegistry < Registry
  @@service_tree_file = '/opt/engines/run/service_manager/services.yaml'   
  
 

  require_relative '../sub_registeries/sub_registry.rb'
  require_relative '../sub_registeries/configurations_registry.rb'
  require_relative '../sub_registeries/managed_engines_registry.rb'
  require_relative '../sub_registeries/services_registry.rb'
  require_relative '../sub_registeries/orphan_services_registry.rb'
  require_relative '../sub_registeries/shares_registry.rb'
  require_relative '../../errors/engines_registry_error.rb'
  require_relative '../system_utils.rb'
  
  require_relative 'shares.rb'
  include Shares
  
  require_relative 'configurations.rb'
  include Configurations
  require_relative 'orphans.rb'
  include Orphans
  require_relative 'services.rb'
  include Services
  require_relative 'engines.rb'
  include Engines
  require_relative 'checks.rb'
  include Checks
  require_relative 'trees.rb'
    include Trees
  require_relative 'subservices.rb'
    include Subservices
         
  def shutdown
      p :GOT_SHUT_DOWN
     roll_back
     unlock_tree
    end
    
  # @ call initialise Service Registry Tree which loads it from disk or create a new one if none exits
  def initialize
    # @service_tree root of the Service Registry Tree
    @system_registry = initialize_tree
    @configuration_registry = ConfigurationsRegistry.new(service_configurations_registry_tree)
    @services_registry = ServicesRegistry.new(services_registry_tree)
    @managed_engines_registry = ManagedEnginesRegistry.new(managed_engines_registry_tree)
    @orphan_server_registry = OrphanServicesRegistry.new(orphaned_services_registry_tree)
    @shares_registry = SharesRegistry.new(shares_registry_tree)
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
  
  
 
   

  def orphanate_service(service_hash)
    take_snap_shot

    if test_orphans_registry_result( @orphan_server_registry.orphanate_service(service_hash))
      save_tree
      if test_services_registry_result(@services_registry.remove_from_services_registry(service_hash))
        return save_tree
      else
        @orphan_server_registry.release_orphan(service_hash)
        log_error_mesg('Failed to save orphan in remove_from_services_registry de orphaning' + @services_registry.last_error.to_s, service_hash)
      end
      log_error_mesg('Failed to save orphan' + @orphan_server_registry.last_error.to_s, service_hash)
    end
    roll_back
    return false
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
  
  def system_registry_tree    

    current_mod_time = File.mtime(@@service_tree_file) unless @last_tree_mod_time == nil 
   # @last_tree_mod_time = nil
      if @system_registry == nil || @last_tree_mod_time.nil? || !@last_tree_mod_time.eql?(current_mod_time)
        @system_registry = load_tree
        # FIXME should be recover tree with warning
        log_error_mesg('Panic nil regsitry loaded', @system_registry) if @system_registry.nil?
        @system_registry = recovery_tree if @system_registry.nil?
        set_registries
      end
    return @system_registry
  rescue StandardError => e
    log_exception(e)
    return nil
  end
  
  def sync
    system_registry_tree    
  end

  def update_managed_engine_service(service_query_hash)
      p :NYI
    return false
    end

 
  private

  require_relative 'file_locking.rb'
  
  def take_snap_shot
    lock_tree
    @configuration_registry.take_snap_shot
    @services_registry.take_snap_shot
    @managed_engines_registry.take_snap_shot
    @orphan_server_registry.take_snap_shot
    @shares_registry.take_snap_shot
    clear_error
  end

  def clear_error
    @last_error = ''
  end

  def roll_back
    p ':++++++++++++++++++++++++++++++++++'
    p ':____________ROLL_BACK_____________:'
    p '++++++++++++++++++++++++++++++++++'
  
    unlock_tree
    @system_registry = load_tree
    set_registries
    return @system_registry
  rescue StandardError => e
    log_exception(e)
  end
  
  # set @registry to the appropirate tree Node for eaach sub resgistry
  # creates node if nil via_xxx_yyy_tree
  def set_registries      

    configuration_registry_tree if @system_registry['Configurations'].nil?
    @configuration_registry.reset_registry(@system_registry['Configurations'])      
    services_registry_tree if @system_registry['Services'].nil?
    @services_registry.reset_registry(@system_registry['Services'])
    orphaned_services_registry_tree if @system_registry['OphanedServices'].nil?
    @orphan_server_registry.reset_registry(@system_registry['OphanedServices']) 
    managed_engines_registry_tree if @system_registry['ManagedEngine'].nil?
    @managed_engines_registry.reset_registry(@system_registry['ManagedEngine']) 
    shares_registry_tree  if @system_registry['Shares'].nil?
   @shares_registry.reset_registry(@system_registry['Shares'])

    rescue StandardError => e
        log_exception(e)
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
    @system_registry << Tree::TreeNode.new('Configurations', 'Service Configurations')
    @system_registry << Tree::TreeNode.new('Shares', 'Shared Services ')
    save_tree
    @system_registry 
  rescue StandardError => e
    puts e.message
    log_exception(e)
  end

  # FIXME this should do a recovery and not a recreate
  def recovery_tree
    @system_registry = Tree::TreeNode.new('Service Manager', 'Managed Services and Engines')
        @system_registry << Tree::TreeNode.new('ManagedEngine', 'Engines')
        @system_registry << Tree::TreeNode.new('Services', 'Managed Services')
        @system_registry << Tree::TreeNode.new('Configurations', 'Service Configurations')
        @system_registry << Tree::TreeNode.new('Shares', 'Shared Services ')
        save_tree
        @system_registry 
      rescue StandardError => e
        puts e.message
        log_exception(e)
  end
  
 
  
    # @sets the service_tree and load mod time
  def load_tree
    clear_error
  unless lock_tree
    p :Failed_to_gain_lock   
    #return nil 
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
