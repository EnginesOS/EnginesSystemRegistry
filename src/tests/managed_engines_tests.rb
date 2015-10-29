

p :MANAGED_ENGINES
p :get_tree_test
  r =   RestClient.get('http://127.0.0.1:4567/system_registry/managed_engines_tree', nil)
 obj = JSON.parse(r, :create_additions => true)
p :MANAGED_ENGINES_tree_error unless obj.is_a?(Tree::TreeNode)

 
p :find_managed_engine_service_hash
params = {}
params[:container_type] = 'service'
params[:publisher_namespace] = 'EnginesSystem'
params[:type_path] = 'dns'
params[:parent_engine] = 'dns'
params[:service_handle] = 'dns'
params[:service_container_name] = 'dns'
r = RestClient.get('http://127.0.0.1:4567/system_registry/engine_service_hash/',{:params => params })
  obj = JSON.parse(r, :create_additions => true)
  p :managed_engine_service_hash_errore unless obj.is_a?(Hash)

    
p :find_managed_engine_service_hashes
params = {}
params[:container_type] = 'service'
params[:parent_engine] = 'auth'
r = RestClient.get('http://127.0.0.1:4567/system_registry/engine_services',{:params => params })
  if  r == 'false'
    p :managed_engine_service_hashes_errore
  else
  obj = JSON.parse(r, :create_additions => true)
  p :managed_engine_service_hashes_errore unless obj.is_a?(Array)
end
  

p :find_managed_engine_nonpersist

params = {}
params[:container_type] = 'service'
params[:parent_engine] = 'mysql_server'
r = RestClient.get('http://127.0.0.1:4567/system_registry/engine_nonpersistant_services/',{:params => params })
  if  r == 'false'
    p :_managed_engine_nonpersist_errore
  else
  obj = JSON.parse(r, :create_additions => true)
  p :_managed_engine_nonpersist_errore unless obj.is_a?(Array)
end
  
p :find_managed_engine_persist

params = {}
params[:container_type] = 'service'
params[:parent_engine] = 'auth'
r = RestClient.get('http://127.0.0.1:4567/system_registry/engine_persistant_services/',{:params => params })
  if  r == 'false'
    p :find_managed_engine_persist_errore
  else
  obj = JSON.parse(r, :create_additions => true)
  p :find_managed_engine_persist_errore unless obj.is_a?(Array)
end
