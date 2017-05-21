DummyApp = Rack::Builder.new do
  use Rack::ShowExceptions
  use Faultline::Rack::Middleware
  use Warden::Manager

  map '/' do
    run(
      proc do |_env|
        [200, { 'Content-Type' => 'text/plain' }, ['Hello from index']]
      end
    )
  end
  # rubocop:disable Lint/AmbiguousBlockAssociation
  map '/crash' do
    run proc { |_env| raise FaultlineTestError }
  end
end
