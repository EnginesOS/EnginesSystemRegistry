
p :MANAGED_SERVCES
r =   RestClient.get('http://127.0.0.1:4567/system_registry/managed_services_tree', nil)
obj = JSON.parse(r, :create_additions => true)
p :MANAGED_SERVCES_tree_error unless obj.is_a?(Tree::TreeNode)