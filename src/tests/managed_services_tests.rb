

test_type('Managed Services Regsitry')

annouce_test("Tree")
obj = rest_get('/system_registry/managed_services_tree', nil)
test_failed('Loading Tree', obj) unless obj.is_a?(Tree::TreeNode)