helpers do
  def authenticate
    if request.env['HTTP_ACCESS_TOKEN'] == 'atest_randy'
      true
    else
      false
    end
  end
  
  require_relative 'converters.rb'

  def  registry_as_hash(tree)
    as_hash(tree)
  end

  def assemble_params(ps, address_params, required_params = nil, accept_params = nil )
    # STDERR.puts( 'assemble_params Address params ' + ps.to_s + ' address keys required ' + address_params.to_s)
    unless ps.nil?
      ps = symbolize_keys(ps)
      a_params = address_params(ps, address_params)
      return EnginesError.new("Missing Address Parameters #{address_params} but only have: #{ps}", :error,'api') if a_params == false
      unless required_params.nil? || required_params.empty?
        if required_params == :all
          a_params.merge!(ps[:api_vars]) if ps.key?(:api_vars)
        else
          r_params = required_params(ps,required_params)
        return EnginesError.new("Missing Parameters #{required_params} but only have:#{ps}", :error,'api') if r_params == false
          a_params.merge!(r_params) unless r_params.nil?
        end
      end
      unless accept_params.nil? || accept_params.empty?
        o_params = optional_params(ps ,accept_params)
        a_params.merge!(o_params) unless o_params.nil?
      end
      a_params
    else
      nil
    end
  end

  def required_params(params, keys)
    mparams = params[:api_vars]
    if mparams.nil?
      false
    else
      match_params(mparams, keys, true)
    end
  end

  def optional_params(params, keys)
    mparams = params[:api_vars]
    mparams = params if mparams.nil?
    match_params(mparams, keys )
  end

  def address_params(params, keys)
    # STDERR.puts( 'Address params ' + params.to_s + ' keys required ' + keys.to_s)
    match_params(params, keys, true)
  end

  def match_params(params, keys, is_required = false)
    unless keys == :all
      unless keys.nil?
        cparams =  {}
        if keys.is_a?(Array)
          for key in keys
            next unless key.is_a?(Symbol)
            # return missing_param key unless param.key?(key)
            return false unless check_required(params, key, is_required)
            cparams[key.to_sym] = params[key] unless params[key].nil?
          end
        else
          return false unless check_required(params, keys, is_required)
          cparams[keys.to_sym] = params[keys]
        end
        cparams
      else
        nil
      end
    else
      params
    end
  rescue StandardError => e
    p e
    p e.backtrace
  end

  def check_required(params, key, is_required)
    r = false
    r = true unless is_required
    r = true if params.key?(key)
    STDERR.puts("missing_key #{key}") unless r == true
    r
  end

end