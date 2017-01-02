
$RegistryLock='/tmp/registry.lock'

def lock_tree
  if File.exist?($RegistryLock)
    sleep 0.5
    sleep 0.6 if File.exist?($RegistryLock)
    log_error_mesg("REGISTRY_LOCKED")
    sleep 0.5 if File.exist?($RegistryLock)
    log_error_mesg("Failed to lock Retrying",$RegistryLock) if File.exist?($RegistryLock) if File.exist?($RegistryLock)
    sleep 0.5
    return log_error_mesg("Failed to lock",$RegistryLock) if File.exist?($RegistryLock)
  end
  FileUtils.touch($RegistryLock)
  return true
end

def unlock_tree
  File.delete($egistryLock) if File.exist?($RegistryLock)
end