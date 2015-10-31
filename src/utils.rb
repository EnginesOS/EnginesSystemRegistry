
def boolean_if_true_false_str(r)
                  if  r == 'true'
                    return true
                  elsif r == 'false'
                   return false
                  end
       return r     
 end
 
def symbolize_keys(hash)
  hash.inject({}){|result, (key, value)|
    new_key = case key
    when String then key.to_sym
    else key
    end
    new_value = case value
    when Hash then self.symbolize_keys(value)
    when Array then
      newval = []
      value.each do |array_val|
        array_val = symbolize_keys(array_val) if array_val.is_a?(Hash)
        newval.push(array_val)
      end
      newval
    when String then
      boolean_if_true_false_str(value)
    else value
    end
    result[new_key] = new_value
    result
  }
end
def log_exception(e)
   e_str = e.to_s()
   e.backtrace.each do |bt|
     e_str += bt + ' \n'
   end
   @@last_error = e_str
   p e_str
   SystemUtils.log_output(e_str, 10)
   f = File.open('/opt/engines/run/service_manager/exceptions.' + Process.pid.to_s, 'a+')
   f.puts(e_str)
   f.close
 end
