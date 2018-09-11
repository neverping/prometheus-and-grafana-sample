require 'sinatra'
require 'sinatra/multi_route'
require 'yaml'
require 'yaml/store'

findings_file = 'contents.yml'

set :bind, '0.0.0.0'
set :port, 8888

error 400..599 do
  'You are doing it wrong!\r\n'
end

get '/', '/findings', '/findings/' do
  @store = YAML::Store.new findings_file
  @store.transaction do
    "#{@store['contents']}\r\n"
  end
end

route :get, :put, :delete, '/findings/:name' do
  @item  = params['name']
  @store = YAML::Store.new findings_file
  @store.transaction do
    @store['contents'] ||= {}
    @store['contents'][@item] ||= 0
    @store['contents'][@item] += 1 if request.env['REQUEST_METHOD'] == 'PUT'
    if request.env['REQUEST_METHOD'] == 'DELETE'
      # TODO: Should we remove bottle if we don't have it?
      @store['contents'][@item] -= 1 unless @store['contents'][@item] == 0
    end
    @total = @store['contents'][@item]
  end
  "Aknowledge for #{@item}. It now has #{@total}\r\n"
end

get '/metrics' do
   #tem que fazer template
end

#get '/foo' do
#  request.body              # request body sent by the client (see below)
#  request.scheme            # "http"
#  request.script_name       # "/example"
#  request.path_info         # "/foo"
#  request.port              # 80
#  request.request_method    # "GET"
#  request.query_string      # ""
#  request.content_length    # length of request.body
#  request.media_type        # media type of request.body
#  request.host              # "example.com"
#  request.get?              # true (similar methods for other verbs)
#  request.form_data?        # false
#  request["SOME_HEADER"]    # value of SOME_HEADER header
#  request.referer           # the referer of the client or '/'
#  request.user_agent        # user agent (used by :agent condition)
#  request.cookies           # hash of browser cookies
#  request.xhr?              # is this an ajax request?
#  request.url               # "http://example.com/example/foo"
#  request.path              # "/example/foo"
#  request.ip                # client IP address
#  request.secure?           # false
#  request.env               # raw env hash handed in by Rack
#  # Example below
#  "#{request.path}"
#end
