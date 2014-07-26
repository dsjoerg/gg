module ESDB
  class Replay < ESDB::Resource
    # POSTs a given replay file to esdb and returns the job ID if it was
    # successfully queued for processing.
    def self.upload(file, channel, ggtracker_received_at)
      replay = self.new
      response = JSON.parse(RestClient.post(replay.url, :file => file, :access_token => ESDB.api_key, :channel => channel, :ggtracker_received_at => ggtracker_received_at.to_f))
      Rails.logger.info response.inspect

      response['job'] ? response['job'] : false
    end
  end
end
