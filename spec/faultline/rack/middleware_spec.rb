require 'spec_helper'

# rubocop:disable Style/DotPosition
RSpec.describe Faultline::Rack::Middleware do
  let(:app) do
    proc { |env| [200, env, 'Bingo bango content'] }
  end

  let(:faulty_app) do
    proc { raise FaultlineTestError }
  end

  let(:post_error_endpoint) do
    'https://xxxxxxxxx.execute-api.ap-northeast-1.amazonaws.com/v0/projects/faultline-rack/errors'
  end

  let(:middleware) { described_class.new(app) }

  def env_for(url, opts = {})
    Rack::MockRequest.env_for(url, opts)
  end

  def wait_for_a_request_with_body(body)
    wait_for(a_request(:post, post_error_endpoint).with(body: body)).to have_been_made.once
  end

  before do
    stub_request(:post, post_error_endpoint).to_return(status: 201, body: '{}')
  end

  describe '#new' do
    it "doesn't add filters if no notifiers are configured" do
      expect do
        expect(described_class.new(faulty_app, :unknown_notifier))
      end.not_to raise_error
    end
  end

  describe '#call' do
    context 'when app raises an exception' do
      context 'and when the notifier name is specified' do
        let(:notifier_name) { :rack_middleware_initialize }

        let(:bingo_post_error_endpoint) do
          'https://xxxxxxxxx.execute-api.ap-northeast-1.amazonaws.com/v1/projects/faultline-bingo/errors'
        end

        let(:expected_body) do
          /"errors":\[{"type":"FaultlineTestError"/
        end

        before do
          Faultline.configure(notifier_name) do |c|
            c.project = 'faultline-bingo'
            c.api_key = 'xxxxXXXXXxXxXXxxXXXXXXXxxxxXXXXXX'
            c.endpoint = 'https://xxxxxxxxx.execute-api.ap-northeast-1.amazonaws.com/v1'
            c.logger = Logger.new('/dev/null')
          end

          stub_request(:post, bingo_post_error_endpoint).to_return(status: 201, body: '{}')
        end

        after { Faultline[notifier_name].close }

        it 'notifies via the specified notifier' do
          expect do
            described_class.new(faulty_app, notifier_name).call(env_for('/'))
          end.to raise_error(FaultlineTestError)

          wait_for(
            a_request(:post, bingo_post_error_endpoint).
              with(body: expected_body)
          ).to have_been_made.once

          expect(
            a_request(:post, post_error_endpoint).
              with(body: expected_body)
          ).not_to have_been_made
        end
      end

      context 'and when the notifier is not configured' do
        it 'rescues the exception, notifies Faultline & re-raises it' do
          expect { described_class.new(faulty_app).call(env_for('/')) }.
            to raise_error(FaultlineTestError)

          wait_for_a_request_with_body(/"errors":\[{"type":"FaultlineTestError"/)
        end

        it 'sends framework version and name' do
          expect { described_class.new(faulty_app).call(env_for('/bingo/bango')) }.
            to raise_error(FaultlineTestError)

          wait_for_a_request_with_body(
            %r("context":{.*"version":"1.2.3 (Rails|Sinatra|Rack\.version)/.+".+})
          )
        end
      end
    end

    context "when app doesn't raise" do
      context 'and previous middleware stored an exception in env' do
        shared_examples 'stored exception' do |type|
          it "notifies on #{type}, but doesn't raise" do
            env = env_for('/').merge(type => FaultlineTestError.new)
            described_class.new(app).call(env)

            wait_for_a_request_with_body(/"errors":\[{"type":"FaultlineTestError"/)
          end
        end

        ['rack.exception', 'action_dispatch.exception', 'sinatra.error'].each do |type|
          include_examples 'stored exception', type
        end
      end

      it "doesn't notify Faultline" do
        described_class.new(app).call(env_for('/'))
        sleep 1
        expect(a_request(:post, post_error_endpoint)).not_to have_been_made
      end
    end

    it 'returns a response' do
      response =  described_class.new(app).call(env_for('/'))

      expect(response[0]).to eq(200)
      expect(response[1]).to be_a(Hash)
      expect(response[2]).to eq('Bingo bango content')
    end
  end

  context 'when Faultline is not configured' do
    it 'returns nil' do
      allow(Faultline[:default]).to receive(:build_notice).and_return(nil)
      allow(Faultline[:default]).to receive(:notify)

      expect { described_class.new(faulty_app).call(env_for('/')) }.
        to raise_error(FaultlineTestError)

      expect(Faultline[:default]).to have_received(:build_notice)
      expect(Faultline[:default]).not_to have_received(:notify)
    end
  end
end
