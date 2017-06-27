module Params
  def self.assemble_params(params, address_params, required_params = nil, accept_params = nil )
    unless params.nil?
      params = RegistryUtils.symbolize_keys(params)
      a_params = self.address_params(params, address_params)
      return EnginesError.new('Missing Address Parameters ' + address_params.to_s + ' but only have:' + params.to_s, :error,'api') if a_params == false

      unless required_params.nil? || required_params.empty?
        if required_params == :all
          a_params.merge!(params[:api_vars]) if params.key?(:api_vars)
          return a_params
        end
        r_params = self.required_params(params,required_params)
        return EnginesError.new('Missing Parameters ' + required_params.to_s + ' but only have:' + params.to_s, :error,'api') if r_params == false
        a_params.merge!(r_params) unless r_params.nil?
      end
      unless accept_params.nil? || accept_params.empty?
        o_params = self.optional_params(params,accept_params)
        a_params.merge!(o_params) unless o_params.nil?
      end
      a_params
    else
      nil
    end

  end

  def self.required_params(params, keys)
    mparams = params[:api_vars]
    if mparams.nil?
      false
    else
      self.match_params(mparams, keys, true)
    end
  end

  def self.optional_params(params, keys)
    mparams = params[:api_vars]
    mparams = params if mparams.nil?
    self.match_params(mparams, keys)
  end

  def self.address_params(params, keys)
    self.match_params(params, keys, true)
  end

  def self.match_params(params, keys, required = false)
    unless keys == :all
      return nil if keys.nil?
      cparams =  {}
      if keys.is_a?(Array)
        for key in keys
          # return missing_param key unless param.key?(key)
          return false unless self.check_required(params, key,required )
          cparams[key.to_sym] = params[key] unless params[key].nil?
        end
      else
        return false unless self.check_required(params, keys,required)
        cparams[keys.to_sym] = params[keys]
      end
      cparams
    else
      params
    end
  rescue StandardError => e
    p e
    p e.backtrace
  end

  def self.check_required(params, key, is_required)
    return true unless is_required
    return true if params.key?(key)
    p :missing_key
    p key
    false
  end

end