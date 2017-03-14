def boolean_if_true_false_str(r)
    return true if r == 'true'
    return false if r == 'false'
    return r
  end

  def symbolize_keys(hash)
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
def as_hash(tree)

   return ({:name => 'No tree'}) if tree.nil?
  h = { }
    h[:name] = tree.name
    h[:content] = tree.content
    h[:children] =  []
   tree.children do |child|
     h[:children].push(as_hash(child))
   end
   h
   end

  