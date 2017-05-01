module Faultline
  module Rack
    class Middleware < Airbrake::Rack::Middleware
      def initialize(app, notifier_name = :default)
        @app = app
        @notifier = Faultline[notifier_name]

        # Prevent adding same filters to the same notifier.
        return if @@known_notifiers.include?(notifier_name)
        @@known_notifiers << notifier_name

        return unless @notifier
        RACK_FILTERS.each do |filter|
          @notifier.add_filter(filter.new)
        end
      end
    end
  end
end
