
def annouce_test(test_name)
  p @test_type.to_s + ':' + test_name
  
end

def test_type(type)
  @test_type = type.to_s
end

def parse_rest_response(r)
  return nil if r.nil? || r = ''
   return false if r == 'false'
   return true if r == 'true'
   res = JSON.parse(r, :create_additions => true)
   return symbolize_keys(res) if res.is_a?(Hash)
   return res 
 rescue
   p "Failed to parse rest response " + r.to_s
     return false
end



require 'rest-client'

def rest_get(path,params)
  parse_rest_response(RestClient.get('http://127.0.0.1:4567' + path, params)) 
end

def rest_post(path,params)
  parse_rest_response(RestClient.post('http://127.0.0.1:4567' + path, params))
end

def rest_put(path,params)
  parse_rest_response(RestClient.put('http://127.0.0.1:4567' + path, params))
end

def rest_delete(path,params)
  parse_rest_response(RestClient.delete('http://127.0.0.1:4567' + path, params))
end