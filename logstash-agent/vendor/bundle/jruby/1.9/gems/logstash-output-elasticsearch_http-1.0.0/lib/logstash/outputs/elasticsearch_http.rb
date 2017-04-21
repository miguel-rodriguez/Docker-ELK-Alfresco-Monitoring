# encoding: utf-8
require "logstash/outputs/elasticsearch"
require "logstash/codecs/base"
require "logstash/namespace"
require "forwardable"

# This plugin is deprecated in favor of using elasticsearch output and the http protocol
# Please update your current configuration!
#
# .Example
# [source,ruby]
#   elasticsearch {
#     protocol => 'http'
#     host => '127.0.0.1'
#   }
class LogStash::Outputs::ElasticsearchHTTP < LogStash::Outputs::Base
  extend Forwardable

  config_name "elasticsearch_http"

  # The index to write events to. This can be dynamic using the %{foo} syntax.
  # The default value will partition your indices by day so you can more easily
  # delete old data or only search specific date ranges.
  config :index, :validate => :string, :default => "logstash-%{+YYYY.MM.dd}"

  # The index type to write events to. Generally you should try to write only
  # similar events to the same 'type'. String expansion '%{foo}' works here.
  config :index_type, :validate => :string

  # Starting in Logstash 1.3 (unless you set option "manage_template" to false)
  # a default mapping template for Elasticsearch will be applied, if you do not
  # already have one set to match the index pattern defined (default of
  # "logstash-%{+YYYY.MM.dd}"), minus any variables.  For example, in this case
  # the template will be applied to all indices starting with logstash-*
  #
  # If you have dynamic templating (e.g. creating indices based on field names)
  # then you should set "manage_template" to false and use the REST API to upload
  # your templates manually.
  config :manage_template, :validate => :boolean, :default => true

  # This configuration option defines how the template is named inside Elasticsearch.
  # Note that if you have used the template management features and subsequently
  # change this you will need to prune the old template manually, e.g.
  # curl -XDELETE <http://localhost:9200/_template/OldTemplateName?pretty>
  # where OldTemplateName is whatever the former setting was.
  config :template_name, :validate => :string, :default => "logstash"

  # You can set the path to your own template here, if you so desire.
  # If not the included template will be used.
  config :template, :validate => :path

  # Overwrite the current template with whatever is configured
  # in the template and template_name directives.
  config :template_overwrite, :validate => :boolean, :default => false

  # The hostname or IP address to reach your Elasticsearch server.
  config :host, :validate => :string, :required => true

  # The port for Elasticsearch HTTP interface to use.
  config :port, :validate => :number, :default => 9200

  # The HTTP Basic Auth username used to access your elasticsearch server.
  config :user, :validate => :string, :default => nil

  # The HTTP Basic Auth password used to access your elasticsearch server.
  config :password, :validate => :password, :default => nil

  # This plugin uses the bulk index api for improved indexing performance.
  # To make efficient bulk api calls, we will buffer a certain number of
  # events before flushing that out to Elasticsearch. This setting
  # controls how many events will be buffered before sending a batch
  # of events.
  config :flush_size, :validate => :number, :default => 100

  # The amount of time since last flush before a flush is forced.
  #
  # This setting helps ensure slow event rates don't get stuck in Logstash.
  # For example, if your `flush_size` is 100, and you have received 10 events,
  # and it has been more than `idle_flush_time` seconds since the last flush,
  # logstash will flush those 10 events automatically.
  #
  # This helps keep both fast and slow log streams moving along in
  # near-real-time.
  config :idle_flush_time, :validate => :number, :default => 1

  # The document ID for the index. Useful for overwriting existing entries in
  # Elasticsearch with the same ID.
  config :document_id, :validate => :string, :default => nil

  # Set the type of Elasticsearch replication to use. If async
  # the index request to Elasticsearch to return after the primary
  # shards have been written. If sync (default), index requests
  # will wait until the primary and the replica shards have been
  # written.
  config :replication, :validate => ['async', 'sync'], :default => 'sync'

  def_delegators :@elasticsearch_output, :teardown, :register, :receive

  def initialize(options = {})
    super(options)

    @logger = Cabin::Channel.get(LogStash)
    warning_message = []

    warning_message << "The elasticsearch_http output is replaced by the elasticsearch output and will be removed in a future version of Logstash"

    if options.delete("replication") == "async"
      warning_message << "Ignoring the async replication option, this option is not recommended and not supported by this plugin"
    end

    # transform configuration
    options["host"] = [options['host']]
    options["protocol"] = "http"

    
    # Generate a migration configuration for the new elasticsearch output
    # using the current settings as the base.
    warning_message << "The following configuration example is based on the options you specified and should work:"
    warning_message << "elasticsearch {"

    @config.each do |option, value|
      if display_option?(option, value)
        warning_message << "#{option} => #{format_value(value)}"
      end
    end

    warning_message << "}\n"

    @logger.warn(warning_message.join("\n"))
    @elasticsearch_output = LogStash::Outputs::ElasticSearch.new(options)
  end

  private
  def format_value(value)
    if value.is_a?(LogStash::Codecs::Base)
      return "\"#{value.class.to_s.split('::').last.downcase}\""
    elsif value.is_a?(String)
      return "\"#{value}\""
    else
      return value
    end
  end

  def display_option?(option, value)
    return false if option == 'password' && @config['user'].nil?
    if !value.nil?
      if value.is_a?(Array) 
        return true if value.size > 0
      elsif value.to_s.size != 0
        return true
      end
    end
  end
end
