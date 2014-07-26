module ESDB
  class Identity < ESDB::Resource
    def to_hash
      get! unless @response
      hash = JSON.parse(@response)

      # Only include stats for ourself.
      hash['stats'] = hash['stats'][hash['id'].to_s] if hash['stats']
      hash
    end

    def race_name
      case most_played_race
      when "p"
        "protoss"
      when "t"
        "terran"
      when "z"
        "zerg"
      else
        nil
      end
    end

    def sc2ranks_url
      if gateway == 'xx'
        nil
      else
        "http://sc2ranks.com/#{gateway}/#{bnet_id}/#{name}"
      end
    end

    def destroy_all_matches
      resp = RestClient.post(url + '/destroy_all_matches', :access_token => ESDB.api_key)
      JSON.parse(resp)
    end
  end
end
