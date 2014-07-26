module ESDB
  class Resource < RestClient::Resource
    attr_accessor :params, :response

    def initialize(url=nil, options={}, *args)
      options[:headers] ||= {}

      # Lets you specify options, finder-like, as the first argument:
      # Resource.new(:id => 123)
      if url.is_a?(Hash)
        options[:headers][:params] ||= {}
        options[:headers][:params].merge!(url)
        url = nil
      end

      # REST is DRY! Let's just guess our url..
      klass_ep = self.class.to_s.scan(/::(.*?)$/).flatten[0].pluralize.underscore
      @url ||= "http://#{GG.config.host}/api/v1/#{klass_ep}"

      # For now, various params will trigger a change in the URI
      # might want to do it more like Rails in esdb ..not sure yet
      @params = options[:headers][:params]
      if @params && @params.any?
        @url += "/#{@params.delete(:id)}" if @params[:id]
        options[:headers][:params][:stats] = StatsParam.new(options[:headers][:params][:stats]) if @params[:stats]
      end

      # And we also default to JSON
      options[:headers][:accept] ||= 'application/json'

      @options = options
      # Screw super, there's nothing useful in it anyway.
      # https://github.com/archiloque/rest-client/blob/master/lib/restclient/resource.rb#L39
      # super(url, *args)
    end

    # Retrieves the resource and unlike RestClient, stores the result in the
    # instance instead of returning it (but also returns it)
    def get!(*args)
      @response = get(*args)
    end

    # TODO: prepare to get rid of RestClient potentially, it's not really
    # maintained anymore anyway. Don't use RestClient specific calls outside
    # of gg itself and give gg an AR-like API.
    #
    # Note: the auth option is not used anywhere currently - ggtracker uses
    # sync below, which always appends the API key anyway. This is needed to
    # retrieve sensible information from esdb, such as the character_code of an
    # identity.
    def self.find(id, options = {})
      resource = options[:auth] ? self.new(id: id, access_token: ESDB.api_key) : self.new(id: id)
      resource.get!

      if (200..207).include?(resource.response.code)
        return resource
      else
        return nil
      end

    rescue => e
      raise ESDB::Exception if e.response && e.response.code != 404
      nil
    end

    # A kind of find_or_create - experimental.
    # For example identities should be created and returned if sufficient
    # identifying data is submitted, but no identity is found.
    # A little HAX'ish right now, need to decide on naming/exact functionality
    def self.sync(attrs = {})
      # TODO: I miss reverse_merge!
      attrs[:access_token] = ESDB.api_key if ESDB.api_key

      resource = self.new(nil, {headers: {params: {id: 'find', create: true}.merge(attrs)}})
      resource.get!
      resource
    end

    def self.from_json(json)
      resource = self.new
      resource.instance_variable_set('@response', json)
      resource
    end

    def self.from_hash(hash)
      resource = self.new

      # TODO: the response= setter is freaky, and I want to get rid of 
      # RestClient anyway.
      resource.instance_variable_set('@response', hash.to_json)
      resource
    end

    def to_hash
      get! unless @response
      JSON.parse(@response)
    end
    
    def method_missing(method, *args)
      @hash ||= to_hash
      return @hash[method.to_s] if @hash.has_key?(method.to_s)
    end
  end
end
