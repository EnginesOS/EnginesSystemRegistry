
def annouce_test(test_name)
  p @test_type.to_s + ':' + test_name
  @current_test = test_name
end

def test_type(type)
  @test_type = type.to_s
  puts ''  
  puts ''
  
  puts ('__________' + type + '___________')

end

def test_failed(message, obj)
  p 'Failed:' + @test_type.to_s + ':' +  @current_test +"->" + message.to_s
  p obj.to_s
end


def parse_rest_response(r)
    return false if r.code > 399
  return true if r.to_s   == '' ||  r.to_s   == 'true'
  return false if r.to_s  == 'false' 
   res = JSON.parse(r, :create_additions => true)     
   return symbolize_keys(res) if res.is_a?(Hash)
   return res 
 rescue
   p "Failed to parse rest response _" + res.to_s + "_"
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