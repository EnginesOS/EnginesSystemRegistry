class SystemUtils
  @@debug = true
  @@level = 5

  attr_reader :debug, :level, :last_error
  def self.debug_output(label, object)
    if SystemUtils.debug == true
      p label.to_sym
      p object
    end
  end

  def self.log_output(object, level)
    if SystemUtils.level < level
      p :Error
      p object.to_s
    end
  end

  # @Logs to passeenger std out the @msg followed by @object.to_s
  # Logs are written to apache/error.log
  # error mesg is truncated to 512 bytes
  # returns nothing
  def self.log_error_mesg(msg, object)
    obj_str = object.to_s.slice(0, 512)
    SystemUtils.log_output(msg + ':->:' + obj_str, 10)
  end

  def self.log_error(object)
    SystemUtils.log_output(object, 10)
  end

  def self.get_service_pubkey(service, cmd)
    cmd_line = 'docker exec ' + service + ' /home/get_pubkey.sh ' + cmd
    key = SystemUtils.run_command(cmd_line)
    p key
    return key
  end

  #  def SystemUtils.system_release
  #    if File.exists?(SystemConfig.ReleaseFile) == false
  #         return 'current'
  #       end
  #       release =  File.read(SystemConfig.ReleaseFile)
  #       return release.strip
  #  end
  #
  #  def SystemUtils.version
  #     return SystemUtils.system_release + '.' + SystemConfig.api_version + '.' + SystemConfig.engines_system_version
  #   end
  #
  def self.symbolize_keys(hash)
    hash.inject({}){|result, (key, value)|
      new_key = case key
      when String then key.to_sym
      else key
      end
      new_value = case value
      when Hash then symbolize_keys(value)
      when Array then
        newval = []
        value.each do |array_val|
          array_val = SystemUtils.symbolize_keys(array_val) if array_val.is_a?(Hash)
          newval.push(array_val)
        end
        newval
      else value
      end
      result[new_key] = new_value
      result
    }
  end

  def self.log_exception(e)
    e_str = e.to_s()
    e.backtrace.each do |bt|
      e_str += bt + ' \n'
    end
    @@last_error = e_str
    p e_str
    SystemUtils.log_output(e_str, 10)
  end

  def self.last_error
    return @@last_error
  end

  def self.level
    return @@level
  end

  def self.debug
    return @@debug
  end

  # Execute @param cmd [String]
  # if sucessful exit code == 0 @return
  # else
  # @return stdout and stderr from cmd
  def self.run_system(cmd)
    @@last_error = ' '
    begin
      cmd += ' 2>&1'
      res = (%x<`#{cmd}`>)
      SystemUtils.debug_output('Run ' + cmd + ' ResultCode:' + $CHILD_STATUS.to_s + ' Output:', res)
      if $CHILD_STATUS.to_i == 0
        p :run_system_success
        return true
      else
        SystemUtils.log_error_mesg('Error Code:' + $CHILD_STATUS.to_s + ' in run ' + cmd + ' Output:', res)
        return res
      end
    rescue StandardError => e
      SystemUtils.log_exception(e)
      SystemUtils.log_error_mesg('StandardError Error in SystemUtils.run_system(cmd): ', res)
      return 'StandardError Error in SystemUtils.run_system(cmd): ' + e.to_s
    end
  end

  def self.hash_string_to_hash(hash_string)
    retval = {}
    hash_pairs = hash_string.split(':')
    hash_pairs.each do |hash_pair|
      pair = hash_pair.split('=')
      if pair.length > 1
        val = pair[1]
      else
        val = nil
      end
    retval[pair[0].to_sym] = val if pair.nil? == false && pair[0].nil? == false

    end
    return retval
  rescue StandardError => e
    SystemUtils.log_exception(e)
  end

  # Execute @param cmd [String]
  # @return hash
  # :result_code = command exit/result code
  # :stdout = what was written to standard out
  # :stderr = wahat was written to standard err
  def self.execute_command(cmd)
    @@last_error = ''
    require 'open3'
    SystemUtils.debug_output('exec command ', cmd)
    retval = {}
    retval[:stdout] = ''
    retval[:stderr] = ''
    retval[:result] = -1
    Open3.popen3(cmd) do |stdin, stdout, stderr, th|
      oline = ''
      stderr_is_open = true
      begin
        stdout.each do |line|
          line = line.gsub(/\\\'/, '')
          oline = line
          retval[:stdout] += line.chop
          #              p :lne_by_line
          #              p line
          retval[:stderr] += stderr.read_nonblock(256) if stderr_is_open
        end
        retval[:result] = th.value.exitstatus
      rescue Errno::EIO
        retval[:stdout] += oline.chop
        retval[:stdout] += stdin.read_nonblock(256)
        SystemUtils.debug_output('read stderr', oline)
        retval[:stderr] += stderr.read_nonblock(256)
      rescue IO::WaitReadable
        retry
      rescue EOFError
        if stdout.closed? == false
          stderr_is_open = false
          retry
        elsif stderr.closed? == false
          retval[:stderr] += stderr.read_nonblock(1000)
        end
      end
      return retval
    end
    return retval
  rescue StandardError => e
    SystemUtils.log_exception(e)
    SystemUtils.log_error_mesg('StandardError Error in SystemUtils.execute_command( ' + cmd + '): ', retval)
    retval[:stderr] += 'StandardError Error in SystemUtils.run_system(' + cmd + '): ' + e.to_s
    retval[:result] = -99
    return retval
  end

  # Execute @param cmd [String]
  # @return stdout and stderr from cmd
  # No indication of success
  def self.run_command(cmd)
    @@last_error = ''
    begin
      cmd += ' 2>&1'
      res = (%x<#`{cmd}`>)
      SystemUtils.debug_output('Run ' + cmd + ' ResultCode:' + $CHILD_STATUS.to_s + ' Output:', res)
      return res
    rescue StandardError => e
      SystemUtils.log_exception(e)
      SystemUtils.log_error_mesg('StandardError Error in SystemUtils.run_system(cmd): ', res)
      return 'StandardError Error in SystemUtils.run_system(cmd): ' + e.to_s
    end
  end

  #  def SystemUtils.get_default_domain
  #    if File.exists?(SystemConfig.DefaultDomainnameFile)
  #      domain = File.read(SystemConfig.DefaultDomainnameFile)
  #      return domain.strip
  #    else
  #      return 'engines'
  #    end
  #  end

  # @return [Hash] completed dns service_hash for engine on the engines.internal dns for
  # @param engine [ManagedContainer]
  def self.create_dns_service_hash(engine)
    service_hash = {}
    service_hash[:publisher_namespace] = 'EnginesSystem'
    service_hash[:type_path] = 'dns'
    service_hash[:parent_engine] = engine.container_name
    service_hash[:container_type] = engine.ctype
    service_hash[:variables] = {}
    service_hash[:variables][:parent_engine] = engine.container_name

    if engine.ctype == 'service'
      service_hash[:variables][:hostname] = engine.hostname
    else
      service_hash[:variables][:hostname] = engine.container_name
    end
    service_hash[:variables][:name] = service_hash[:variables][:hostname]
    service_hash[:container_type] = engine.ctype
    service_hash[:variables][:ip] = engine.get_ip_str.to_s
    service_hash[:service_handle] = service_hash[:variables][:name]
    p :created_dns_service_hash
    p service_hash
    return service_hash
  end

  # @return [Hash] completed nginx service_hash for engine on for the default website configured for
  # @param engine [ManagedContainer]
  def self.create_nginx_service_hash(engine)
    proto = 'http_https'
    case engine.protocol
    when :https_only
      proto = 'https'
    when :http_and_https
      proto = 'http_https'
    when :http_only
      proto = 'http'
    end
    #
    #    p :proto
    #    p proto
    service_hash = {}
    service_hash[:variables] = {}
    service_hash[:parent_engine] = engine.container_name
    service_hash[:variables][:parent_engine] = engine.container_name
    service_hash[:variables][:name] = engine.container_name
    service_hash[:service_handle] = engine.fqdn
    service_hash[:container_type] = engine.ctype
    service_hash[:variables][:fqdn] = engine.fqdn
    service_hash[:variables][:port] = engine.port.to_s
    service_hash[:variables][:proto] = proto
    service_hash[:type_path] = 'nginx'
    service_hash[:publisher_namespace] = 'EnginesSystem'
    SystemUtils.debug_output('create nginx Hash', service_hash)
    return service_hash
  end

  def self.service_hash_variables_as_str(service_hash)
    argument = ''
    argument = 'publisher_namespace=' + service_hash[:publisher_namespace] + ':type_path=' + service_hash[:type_path] + ':' if service_hash.key?(:publisher_namespace)
    service_variables = service_hash[:variables]
    sources = ''
    return argument if service_variables.nil? == true

    service_variables.each_pair do |key, value|
      if key == :sources
        sources = value
        next
      end
      argument += key.to_s + '=\'' + value.to_s + '\':'
    end
    argument += ' ' + sources
    return argument
  end
end
