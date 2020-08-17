class RegistryUtils
  # require_relative 'params.rb'
  def RegistryUtils.boolean_if_true_false_str(r)
    if r == 'true'
      true
    elsif r == 'false'
      false
    else
      r
    end
  end

  def RegistryUtils.symbolize_keys(hash)
    hash.inject({}){|result, (key, value)|
      new_key = case key
      when String then key.to_sym
      else key
      end
      new_value = case value
      when Hash then RegistryUtils.symbolize_keys(value)
      when Array then
        newval = []
        value.each do |array_val|
          array_val = RegistryUtils.symbolize_keys(array_val) if array_val.is_a?(Hash)
          newval.push(array_val)
        end
        newval
      when String then
        RegistryUtils.boolean_if_true_false_str(value)
      else value
      end
      result[new_key] = new_value
      result
    }
  end

  def  RegistryUtils.as_hash(tree)
    unless tree.nil?
      h = {
        name: tree.name,
        content: tree.content,
        children: []
      }
      tree.children do |child|
        h[:children].push(as_hash(child))
      end
      h
    else
      {:name => 'No tree'}
    end
  end

  def RegistryUtils.log_exception(e)
  e_str = "#{e}"
    e.backtrace.each do |bt|
      e_str += "#{bt} \n"
    end

    SystemUtils.log_output(e_str, 10)
    f = File.open("/opt/engines/run/service_manager/exceptions.#{Process.pid}", 'a+')
    f.puts(e_str)
    f.close
    false
  end

end
