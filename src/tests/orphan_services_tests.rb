p :ORPHAN_SERVICES
r =   RestClient.get('http://127.0.0.1:4567/system_registry/orphan_services_tree', nil)
obj = JSON.parse(r, :create_additions => true)
p obj.class.name
p :ORPHAN_SERVCES_tree_error unless obj.is_a?(Tree::TreeNode)