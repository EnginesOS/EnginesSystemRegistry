module Checks
  # @return boolean true if not nil
  def check_system_registry_tree
    clear_error
    st = system_registry_tree
    return SystemUtils.log_error_mesg('Nil service tree ?', st) if !st.is_a?(Tree::TreeNode)
    return true
  rescue StandardError => e
    log_exception(e)
  end
#
#  def test_subservices_registry_result(result)
#    @last_error = @last_error.to_s + ':' + @subservices_registry.last_error.to_s  if result.is_a?(FalseClass) || result.nil?
#     result
#  end
#
#  def test_orphans_registry_result(result)
#    @last_error = @last_error.to_s + ':' + @orphan_server_registry.last_error.to_s  if result.is_a?(FalseClass) || result.nil?
#     result
#  end
#
#  def test_engines_registry_result(result)
#    @last_error = @last_error.to_s + ':' + @managed_engines_registry.last_error.to_s if result.is_a?(FalseClass) || result.nil?
#     result
#  end
#
#  def test_services_registry_result(result)
#    @last_error = @last_error.to_s + ':' + @services_registry.last_error.to_s if result.is_a?(FalseClass) || result.nil?
#     result
#  end
#
#  def test_configurations_registry_result(result)
#    @last_error = @last_error.to_s + ':' + @configuration_registry.last_error.to_s if result.is_a?(FalseClass) || result.nil?
#     result
#  end
end