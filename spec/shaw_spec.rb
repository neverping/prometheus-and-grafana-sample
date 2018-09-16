ENV['RACK_ENV'] = 'test'

require 'spec_helper'
require 'rack/test'
require 'test/unit'
require_relative '../sinatra/shaw'

# TODO: IMPROVE THIS
mocked_file = 'contents.yml'
File.delete(mocked_file) if File.file?(mocked_file)

class SinatraShawTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_get_slash
    get '/'
    assert last_response.ok?
  end

 def test_get_findings
    get '/findings/bottle'
    assert last_response.ok?
    assert last_response.body.include?('Aknowledge for bottle. It now has 0')
  end

  def test_put_findings
    put '/findings/bottle'
    header 'User-Agent', 'Weyland'
    header 'Content-Type', 'text/plain; charset=utf-8'
    assert last_response.ok?
    assert last_response.body.include?('Aknowledge for bottle. It now has 1')
  end

  def test_delete_findings
    delete '/findings/bottle'
    header 'User-Agent', 'Weyland'
    header 'Content-Type', 'text/plain; charset=utf-8'
    assert last_response.ok?
    assert last_response.body.include?('Aknowledge for bottle. It now has 0')
  end

end
