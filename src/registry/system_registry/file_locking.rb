
def registry_lock
  '/tmp/registry.lock'
end

def lock_tree
  if File.exist?(registry_lock)
    sleep 0.5
    sleep 0.6 if File.exist?(registry_lock)
    log_error_mesg("REGISTRY_LOCKED")
    sleep 0.5 if File.exist?(registry_lock)
    log_error_mesg("Failed to lock Retrying",registry_lock) if File.exist?(registry_lock) if File.exist?(registry_lock)
    sleep 0.5
    return log_error_mesg("Failed to lock",registry_lock) if File.exist?(registry_lock)
  end
  FileUtils.touch(registry_lock)
   true
end

def unlock_tree
  File.delete(registry_lock) if File.exist?(registry_lock)
end