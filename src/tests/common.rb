
def annouce_test(test_name)
  p @test_type.to_s + ':' + test_name
  @current_test = test_name
end

def test_type(type)
  @test_type = type.to_s
end

def test_failed(message, obj)
  p 'Failed:' + @test_type.to_s + ':' +  @current_test +"->" + message.to_s
  p obj.to_s
end


def parse_rest_response(r)
  return false if r.nil? || r == ''
   return false if r == 'false'
   return true if r == 'true'
    return false if r.code > 399
   res = JSON.parse(r, :create_additions => true)   
  return false if ( res.nil? || res.to_s == '' ) &&  r.code  < 399
   return symbolize_keys(res) if res.is_a?(Hash)
   return res 
 rescue
   p "Failed to parse rest response " + r.to_s
     return false
end

def base_url
  'http://127.0.0.1:4567'
end

require 'rest-client'

def rest_get(path,params)
  parse_rest_response(RestClient.get(base_url + path, params)) 
end

def rest_post(path,params)
  parse_rest_response(RestClient.post(base_url + path, params))
end

def rest_put(path,params)
  parse_rest_response(RestClient.put(base_url + path, params))
end

def rest_delete(path,params)
  parse_rest_response(RestClient.delete(base_url + path, params))
end