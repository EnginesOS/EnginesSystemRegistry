module Shares
  def add_to_shares_registry(service_hash)
    take_snap_shot
    if @shares_registry.add_to_shares_registry(service_hash)
      save_tree
    else
      unlock_tree
      false
    end
  rescue StandardError => e
    roll_back
    raise e
  end

  def remove_from_shares_registry(service_hash)
    take_snap_shot
    if @shares_registry.remove_from_shares_registry(service_hash)
      save_tree
    else
      log_error_mesg('FAILED to remove share service_node ' )
      unlock_tree
      false
    end
  rescue StandardError => e
    roll_back
    raise e
  end

end