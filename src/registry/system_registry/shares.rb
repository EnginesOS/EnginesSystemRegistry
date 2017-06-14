module Shares
  def add_to_shares_registry(service_hash)
    take_snap_shot
    return save_tree if @shares_registry.add_to_shares_registry(service_hash)
    unlock_tree
    false
  rescue StandardError => e
    roll_back
    handle_exception(e)
  end

  def remove_from_shares_registry(service_hash)
    take_snap_shot
    return save_tree if @shares_registry.remove_from_shares_registry(service_hash)
    log_error_mesg('FAILED to remove share service_node ' )
    unlock_tree
    false
  rescue StandardError => e
    roll_back
    handle_exception(e)
  end

end