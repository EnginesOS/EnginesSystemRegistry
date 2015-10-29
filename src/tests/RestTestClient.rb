

  require 'rubytree'
require_relative '../utils.rb'
  
require_relative 'common.rb'

annouce_test('Registry Status')
obj = rest_get('/system_registry/status/', nil)
test_failed('Registry Status', obj) unless obj  == 'OK'

require_relative 'configuration_tests.rb'
require_relative 'managed_engines_tests.rb'
require_relative 'managed_services_tests.rb'
require_relative 'orphan_services_tests.rb'

