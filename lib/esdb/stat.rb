module ESDB
  class Stat < ESDB::Resource
    def to_hash
      get! unless @response
      {'stats' => JSON.parse(@response)}
    end
  end
end
