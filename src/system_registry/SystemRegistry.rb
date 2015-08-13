require_relative 'Registry.rb'
require 'yaml'
require 'fileutils'
class SystemRegistry < Registry 

  require_relative 'SubRegistry.rb'
  require_relative 'ConfigurationsRegistry.rb'
  require_relative 'ManagedEnginesRegistry.rb'
  require_relative 'ServicesRegistry.rb'
  require_relative 'OrphanServicesRegistry.rb'
  require_relative 'SystemUtils.rb'
  
 def test_orphans_registry_result(result)
   if result == nil || result == false
     @last_error=   @last_error.to_s + ":" + @orphan_server_registry.last_error
   end
   return result
 end
  def test_engines_registry_result(result)
    if result == nil || result == false
      @last_error=   @last_error.to_s + ":" + @managed_engines_registry.last_error
    end
    
    return result
  end
  
  def test_services_registry_result(result)
    if result == nil || result == false
      @last_error=   @last_error.to_s + ":" + @services_registry.last_error
    end
    
    return result
   end
  def test_configurations_registry_result(result)
    if result == nil || result == false
      @last_error=   @last_error.to_s + ":" + @configuration_registry.last_error
    end
    
    return result
   end
   
  #@ call initialise Service Registry Tree which loads it from disk or create a new one if none exits
   def initialize() 
     #@service_tree root of the Service Registry Tree
     @system_registry = initialize_tree
     @configuration_registry = ConfigurationsRegistry.new(service_configurations_registry)
     @services_registry = ServicesRegistry.new(services_registry)
     @managed_engines_registry = ManagedEnginesRegistry.new( managed_engines_registry)
     @orphan_server_registry = OrphanServicesRegistry.new( orphaned_services_registry)
     
   end
   
   def take_snap_shot
     @snap_shot=@system_registry.dup
     clear_error
   end
   
   def clear_error
     @last_error=""
   end
   
   def roll_back
     if @snap_shot.is_a?(Tree::TreeNode)
       @system_registry = @snap_shot
     end
     return @system_registry
   end
   
   def find_engine_services_hashes(params)
     clear_error
     test_engines_registry_result(@managed_engines_registry.find_engine_services_hashes(params))
   end
   
#  def save_as_orphan(params)
#    if  @orphan_server_registry.save_as_orphan(params) == true
#      save_tree
#    end
#  end  
  def rebirth_orphan(params)
    take_snap_shot
    if  test_orphans_registry_result(@orphan_server_registry.rebirth_orphan(params)) == true
      return save_tree
  end
    roll_back
    return false
   end  
#  def reparent_orphan(params)
#    if  @orphan_server_registry.reparent_orphan(params) == true
#    save_tree
#  end
 # end
  def retrieve_orphan(params)
    clear_error
    test_orphans_registry_result(@orphan_server_registry.retrieve_orphan(params))
    end
    
  def get_orphaned_services(params)
    clear_error
    
    test_orphans_registry_result(@orphan_server_registry.get_orphaned_services(params))
   end
  def find_orphan_consumers(params)
    clear_error
    test_orphans_registry_result(@orphan_server_registry.find_orphan_consumers(params))
  end  
    
  def find_service_consumers(service_query_hash)
    clear_error
    test_services_registry_result(@services_registry.find_service_consumers(service_query_hash))
  end
 
  
    def get_service_entry(service_query_hash)
      clear_error
        tree_node = find_service_consumers(service_query_hash)
          if tree_node.is_a?(Tree::TreeNode) == false
            return false                 
          end
          return tree_node.content
    end
  #
  
  def update_attached_service(service_hash) 
    take_snap_shot
    if test_services_registry_result(@services_registry.remove_from_services_registry(service_hash)) &&
      test_services_registry_result(@services_registry.remove_from_services_registry(service_hash)) &&
      test_engines_registry_result(@managed_engines_registry.add_to_managed_engines_registry(service_hash)) &&
      test_engines_registry_result(@managed_engines_registry.add_to_services_registry(service_hash)) == true
#    end
#   if remove_from_managed_engines_registry(service_hash) &&
#    remove_from_services_registry(service_hash) &&
#    add_to_managed_engines_registry(service_hash) &&
#    add_to_services_registry(service_hash) == true    
      return save_tree    
   end
    roll_back
   return false
  end
  
  def add_to_services_registry(service_hash)
    take_snap_shot
    if  test_services_registry_result(@services_registry.add_to_services_registry(service_hash)) == true
      return save_tree
  end
  end   
  
  def remove_from_services_registry(service_hash)
   take_snap_shot
    if  test_services_registry_result(@services_registry.remove_from_services_registry(service_hash)) == true
      return save_tree
  end
    roll_back
   return false
  
   end
   
  def orphanate_service(service_query_hash)
    take_snap_shot
    service_hash = test_orphans_registry_result(@orphan_server_registry.retrieve_orphan(service_query_hash))
    if service_hash == nil
      log_error_mesg(@orphan_server_registry.last_error.to_s)      
      return false
    end 
    if  test_orphans_registry_result( @orphan_server_registry.orphanate_service(service_hash)  ) == true
         if  test_services_registry_result(@services_registry.remove_from_services_registry(service_hash)) == true
          return save_tree
         else
           log_error_mesg("Failed to save orphan" + @services_registry.last_error.to_s,service_hash) 
       end
       log_error_mesg("Failed to save orphan" + @orphan_server_registry.last_error.to_s ,service_hash) 
      end
    roll_back
   return false  
  end
 
  def service_is_registered?(service_hash)
    clear_error
    test_services_registry_result(@services_registry.service_is_registered?(service_hash))
  end
  
  def  find_engine_services_hashes(params)
    clear_error
    test_engines_registry_result(@managed_engines_registry.find_engine_services_hashes(params))
  end
  def find_engine_services(params)
    clear_error
    test_engines_registry_result(@managed_engines_registry.find_engine_services(params))
  end
  def get_engine_nonpersistant_services(params)
    clear_error
    test_engines_registry_result(@managed_engines_registry.get_engine_persistance_services(params,false))
  end
  def get_engine_persistant_services(params)
    clear_error
    test_engines_registry_result(@managed_engines_registry.get_engine_persistance_services(params,true))
  end
  def remove_from_managed_engines_registry(service_hash)
    take_snap_shot
    if  test_engines_registry_result(@managed_engines_registry.remove_from_engine_registry(service_hash)) == true
      return save_tree
  end   
    roll_back
    return false 
  end
  def add_to_managed_engines_registry(service_hash)
    take_snap_shot
    if  test_engines_registry_result(@managed_engines_registry.add_to_managed_engines_registry(service_hash)) == true
    save_tree
  end
       roll_back
       return false    
   end
   
  def get_service_configurations_hashes(service_hash)
    clear_error
    test_configurations_registry_result(@configuration_registry.get_service_configurations_hashes(service_hash))
  end
   
  
  def update_service_configuration(config_hash)
    take_snap_shot
    if  test_configurations_registry_result(@configuration_registry.update_service_configuration(config_hash)) == true
    save_tree
  end
    roll_back
       return false      
  end
  
  #@return an [Array] of service_hashes regsitered against the Service params[:publisher_namespace] params[:type_path]
    def get_registered_against_service(params)
      clear_error
      test_services_registry_result(@services_registry.get_registered_against_service(params))
    
    end
    
  


  
  def list_providers_in_use
    clear_error
    test_services_registry_result(@services_registry.list_providers_in_use)
  end
  
 
  
  #@return boolean true if not nil
  def    check_system_registry_tree
    clear_error
    st = system_registry_tree
    if   st.is_a?(Tree::TreeNode) == false
      SystemUtils.log_error_mesg("Nil service tree ?",st)
      return false
    end
    return true
  rescue
    rescue Exception=>e
             log_exception(e)
             return false
  end
  
  def system_registry_tree
    clear_error
    service_tree_file = "/opt/engines/run/service_manager/services.yaml"
    registry=@system_registry
    if @last_tree_mod_time && @last_tree_mod_time != nil 
          current_time = File.mtime( service_tree_file)
          if  @last_tree_mod_time.eql?(current_time) == false
           registry = load_tree
          end
    end
    @system_registry=registry
    return  registry 
    rescue Exception=>e
    log_exception(e)
      return false
  end

  
  def service_configurations_registry
    clear_error
    if check_system_registry_tree == false
          return false
        end
    if ( @system_registry ["Configurations"] == nil )
      @system_registry  << Tree::TreeNode.new("Configurations","Service Configurations")       
    end
    return  @system_registry ["Configurations"]
    rescue Exception=>e
         log_exception(e)
         return nil
  end
  
  #loads the Service tree off disk from [SysConfig.ServiceTreeFile]
    #calls [log_exception] on error and returns nil 
    #@return service_tree [TreeNode]
    def tree_from_yaml()
      clear_error
      begin
        service_tree_file = "/opt/engines/run/service_manager/services.yaml"
        if File.exist?(service_tree_file)
          tree_data = File.read(service_tree_file)
        elsif  File.exist?(service_tree_file + ".bak")
          tree_data = File.read(service_tree_file + ".bak")
        end
        registry =   YAML::load(tree_data)
        return registry
      rescue Exception=>e
        puts e.message + " with " + tree_data.to_s
        log_exception(e)
        return nil
      end
 
    end
    
  
  
  # Load tree from file or create initial service tree
   #@return ServiceTree as a [TreeNode]
   def initialize_tree
     
     service_tree_file = "/opt/engines/run/service_manager/services.yaml"
     
     if File.exists?(service_tree_file)
       registry = load_tree
     else
       registry = Tree::TreeNode.new("Service Manager", "Managed Services and Engines")
       registry << Tree::TreeNode.new("ManagedEngine","Engines")
       registry << Tree::TreeNode.new("Services","Managed Services")
     end
 
     return registry
   rescue Exception=>e
     puts e.message
     log_exception(e)
 
   end
   
  #@sets the service_tree and loast mod time 
   def load_tree
     clear_error
     service_tree_file = "/opt/engines/run/service_manager/services.yaml"
      registry = tree_from_yaml()
     if File.exist?(service_tree_file)
      @last_tree_mod_time = File.mtime(service_tree_file)
     else
       @last_tree_mod_time =nil
     end
     return registry
     rescue Exception=>e
         @last_error=( "load tree")
         log_exception(e)
         return false
   end
   
 #saves the Service tree to disk at [SysConfig.ServiceTreeFile] and returns tree  
  # calls [log_exception] on error and returns false
    #@return boolean 
    def save_tree
  
      clear_error
      service_tree_file = "/opt/engines/run/service_manager/services.yaml"
      if File.exists?(service_tree_file)
        statefile_bak = service_tree_file + ".bak"
        FileUtils.copy( service_tree_file,   statefile_bak)
      end
      serialized_object = YAML::dump(@system_registry)
      f = File.new(service_tree_file+".tmp",File::CREAT|File::TRUNC|File::RDWR, 0644)
      f.puts(serialized_object)
      f.close
      #FIXME do a del a rename as killing copu part way through ...
      FileUtils.copy(service_tree_file+".tmp", service_tree_file);
      @last_tree_mod_time = File.mtime(service_tree_file)
      @snap_shot=nil
      return true
    rescue Exception=>e
      @last_error=( "save error")
      log_exception(e)
      if File.exists?(service_tree_file) == false
        FileUtils.copy(service_tree_file + ".bak", service_tree_file)
      end 
      return false
    end
    
#@return the ManagedServices Tree [TreeNode] Branch
   #  creates if does not exist
  def services_registry()

    clear_error
    if check_system_registry_tree == false
      return false
    end
    if @system_registry["Services"].is_a?(Tree::TreeNode) == false
      @system_registry << Tree::TreeNode.new("Services"," Service register")       
     end
   
     return @system_registry["Services"]
       
    rescue Exception=>e
         log_exception(e)
         return false
  end



def orphaned_services_registry

  clear_error
    if check_system_registry_tree == false 
          return false
        end
    orphans = @system_registry["OphanedServices"]
    if orphans.is_a?(Tree::TreeNode) == false
      @system_registry << Tree::TreeNode.new("OphanedServices","Persistant Services left after Engine Deinstall")
      orphans = @system_registry["OphanedServices"]
    end

    return orphans
    rescue Exception=>e
         log_exception(e)
         return nil
  end
 
# @return the ManagedEngine Tree Branch
  # creates if does not exist
  def managed_engines_registry 

    clear_error
    if check_system_registry_tree == false
          return false
        end
    if @system_registry["ManagedEngine"].is_a?(Tree::TreeNode) == false
      @system_registry << Tree::TreeNode.new("ManagedEngine","ManagedEngine Service register")       
    end
    return @system_registry["ManagedEngine"]
    rescue Exception=>e
         log_exception(e)
         return false
  end
  
  
end