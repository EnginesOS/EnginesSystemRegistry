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
  
  
   
  #@ call initialise Service Registry Tree which loads it from disk or create a new one if none exits
   def initialize() 
     #@service_tree root of the Service Registry Tree
     @system_registry = initialize_tree
     @configuration_registry = ConfigurationsRegistry.new(service_configurations_registry)
     @services_registry = ServicesRegistry.new(services_registry)
     @managed_engines_registry = ManagedEnginesRegistry.new( managed_engines_registry)
     @orphan_server_registry = OrphanServicesRegistry.new( orphaned_services_registry)
     
   end
   
   def find_engine_services_hashes(params)
     @managed_engines_registry.find_engine_services_hashes(params)
   end
   
#  def save_as_orphan(params)
#    if  @orphan_server_registry.save_as_orphan(params) == true
#      save_tree
#    end
#  end  
  def rebirth_orphan(params)
    if  @orphan_server_registry.rebirth_orphan(params) == true
    save_tree
  end
   end  
#  def reparent_orphan(params)
#    if  @orphan_server_registry.reparent_orphan(params) == true
#    save_tree
#  end
 # end
  def retrieve_orphan(params)
      @orphan_server_registry.retrieve_orphan(params)
    end
    
  def get_orphaned_services(params)
    @orphan_server_registry.get_orphaned_services(params)
   end
  def find_orphan_consumers(params)
     @orphan_server_registry.find_orphan_consumers(params)
  end  
    
  def find_service_consumers(service_query_hash)
    @services_registry.find_service_consumers(service_query_hash)
  end
 
  def update_attached_service(service_hash)
   if remove_from_managed_engines_registry(service_hash) &&
    remove_from_services_registry(service_hash) &&
    add_to_managed_engines_registry(service_hash) &&
    add_to_services_registry(service_hash) == true    
    return true
   end
   return false
  end
  
  def add_to_services_registry(service_hash)
    if  @services_registry.add_to_services_registry(service_hash) == true
    save_tree
  end
  end   
  def remove_from_services_registry(service_hash)
    if  @services_registry.remove_from_services_registry(service_hash) == true
    save_tree
  end
   end
   
  def orphanate_service(service_hash)
    if   @orphan_server_registry.save_as_orphan(service_hash) == true
         return  remove_from_services_registry(service_hash)
       end
       log_error_mesg("Failed to save orphan",service_hash)   
       return false
  end
  
 
  def service_is_registered?(service_hash)
    @services_registry.service_is_registered?(service_hash)
  end
  
  def  find_engine_services_hashes(params)
    @managed_engines_registry.find_engine_services_hashes(params)
  end
  def find_engine_services(params)
    @managed_engines_registry.find_engine_services(params)
  end
  def get_engine_nonpersistant_services(params)
    @managed_engines_registry.get_engine_persistance_services(params,false)
  end
  def get_engine_persistant_services(params)
    @managed_engines_registry.get_engine_persistance_services(params,true)
  end
  def remove_from_managed_engines_registry(service_hash)
    if  @managed_engines_registry.remove_from_engine_registry(service_hash) == true
    save_tree
  end    
  end
  def add_to_managed_engines_registry(service_hash)
    if  @managed_engines_registry.add_to_managed_engines_registry(service_hash) == true
    save_tree
  end    
   end
   
  def get_service_configurations_hashes(service_hash)
    @configuration_registry.get_service_configurations_hashes(service_hash)
  end
   
  
  def update_service_configuration(config_hash)
    if  @configuration_registry.update_service_configuration(config_hash) == true
    save_tree
  end    
  end
  
  #@return an [Array] of service_hashes regsitered against the Service params[:publisher_namespace] params[:type_path]
    def get_registered_against_service(params)
      @services_registry.get_registered_against_service(params)
    
    end
    
  


  
  def list_providers_in_use
    @services_registry.list_providers_in_use
  end
  
 
  
  #@return boolean true if not nil
  def    check_system_registry_tree
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