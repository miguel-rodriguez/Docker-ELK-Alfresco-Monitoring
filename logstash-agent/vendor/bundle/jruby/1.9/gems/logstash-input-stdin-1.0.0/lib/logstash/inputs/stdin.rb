# encoding: utf-8
require "logstash/inputs/base"
require "logstash/namespace"
require "concurrent/atomics"
require "socket" # for Socket.gethostname

# Read events from standard input.
#
# By default, each event is assumed to be one line. If you
# want to join lines, you'll want to use the multiline filter.
class LogStash::Inputs::Stdin < LogStash::Inputs::Base
  config_name "stdin"

  default :codec, "line"

  def initialize(*args)
    super(*args)
    @stop_requested = Concurrent::AtomicBoolean.new(false)
  end

  def register
    @host = Socket.gethostname
    fix_streaming_codecs
  end

  def run(queue)
    while @stop_requested.false?
      begin
        # Based on some testing, there is no way to interrupt an IO.sysread nor
        # IO.select call in JRuby. Bummer :(
        data = $stdin.sysread(16384)
        @codec.decode(data) do |event|
          decorate(event)
          event["host"] = @host if !event.include?("host")
          queue << event
        end
      rescue IOError, EOFError, LogStash::ShutdownSignal
        # stdin closed or a requested shutdown
        @stop_requested.make_true
        break
      rescue => e
        # ignore any exception in the shutdown process
        break if @stop_requested.true?
        raise(e)
      end
    end
    finished
  end

  def teardown
    @stop_requested.make_true
    @logger.debug("stdin shutting down.")
    $stdin.close rescue nil
    finished
  end
end
