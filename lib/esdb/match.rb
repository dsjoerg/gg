module ESDB
  class Match < ESDB::Resource

    # Does the match have any summary data?
    def summaries?
      hash = self.to_hash
      if hash['entities'].any?
        summaries = hash['entities'].collect{|e| e['summary']}
        return summaries.reject{|s| s.nil? || s.empty?}.any?
      end
      false
    end

    # Does the match have replays?
    def replays?
      self.replays_count && self.replays_count > 0
    end

    def map
      Hashie::Mash.new(self.to_hash['map'])
    end

    def replays
      return [] if self.to_hash['replays'].blank?
      self.to_hash['replays'].collect{|replay| Hashie::Mash.new(replay)}
    end

    # Combines all entities into a hash keys with the team number
    def teams
      entities.inject({}){|teams, entity| 
        teams[entity['team']] ||= []
        teams[entity['team']] << entity
        teams
      }
    end

    def duration_minutes
      return (duration_seconds / 60.0).round
    end

    def userdelete(user_id)
      resp = RestClient.post(url + '/userdelete', :access_token => ESDB.api_key, :user_id => user_id)
      JSON.parse(resp)
    end

    def expansion_tag
      case expansion
      when 0
        return 'WoL'
      when 1
        return 'HotS'
      when 2
        return 'LotV'
      else
        return '????'
      end
    end

    def expansion_long
      case expansion
      when 0
        return 'Wings of Liberty'
      when 1
        return 'Heart of the Swarm'
      when 2
        return 'Legacy of the Void'
      else
        return 'Unrecognized Expansion'
      end
    end
  end
end
