# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"
#require "logstash/environment"

class LogStash::Filters::SimpleDelta < LogStash::Filters::Base

  config_name "simpledelta"
  milestone 1

  config :input_field, :validate => :string
  config :output_field, :validate => :string

  public
  def initialize(config = {})
    super

  end # def initialize

  public
  def register
 
  end # def register

  public
  def filter(event)

     if !@lastEvent.nil? 
       event[@output_field] = 
        (event[@input_field].to_f) - (@lastEvent[@input_field]).to_f       
     end

     # remember event for next time
     @lastEvent = event
       
  end # def filter

end # class LogStash::Filters::SimpleDelta