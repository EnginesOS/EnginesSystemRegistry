@@RegistryLock='/tmp/registry.lock'

def lock_tree
   if File.exist?(@@RegistryLock)
     sleep 1
     sleep 1 if File.exist?(@@RegistryLock)
     p :REGISTRY_LOCKED
     sleep 1 if File.exist?(@@RegistryLock)
      log_error_mesg("Failed to lock",@@RegistryLock) if File.exist?(@@RegistryLock)
      return true
   end
   FileUtils.touch(@@RegistryLock)
   return true
 end
 
 def unlock_tree
   File.delete(@@RegistryLock) if File.exist?(@@RegistryLock)
   end