def registry_lock
  '/tmp/registry.lock'
end

def lock_tree
  if File.exist?(registry_lock)
    log_error_mesg("REGISTRY_LOCKED")
    sleep 0.5
    log_error_mesg("REGISTRY_LOCKED .5" )
    sleep 0.6 if File.exist?(registry_lock)
    log_error_mesg("REGISTRY_LOCKED 1.1")
    sleep 0.5 if File.exist?(registry_lock)
    log_error_mesg("REGISTRY_LOCKED 1.6")
    log_error_mesg("Failed to lock Retrying",registry_lock) if File.exist?(registry_lock) if File.exist?(registry_lock)
    sleep 0.5 if File.exist?(registry_lock)
    log_error_mesg("REGISTRY_LOCKED 2.1")

  end
  if File.exist?(registry_lock)
    log_error_mesg("Failed to lock",registry_lock)
  else
    FileUtils.touch(registry_lock)
    true
  end
end

def unlock_tree
  File.delete(registry_lock) if File.exist?(registry_lock)
end