require 'logger'
require 'grape/middleware/globals'
require 'grape/middleware/logger/version'

Grape::Middleware.send :remove_const, :Logger if defined? Grape::Middleware::Logger
module Grape
  module Middleware
    class Logger < Grape::Middleware::Globals

      def log
        @log ||= {
          'timestamp' => start_time.iso8601,
          'application' => application,
          'service'     => service,
          'fields'=> {
            'method' =>   env['grape.request'].request_method,
            'resource' => env['grape.request'].path,
            'params' =>   parameters
          },
          'status_code' =>  '',
          'completed_in' => '',
          'errors' => ''
        }
      end

      def before
        start_time
        super
      end

      def call!(env)
        @env = env
        before
        error = catch(:error) { @app_response = @app.call(@env); nil }
        if error.nil?
          if @app_response.respond_to?(:first)
            after(@app_response.first)
          else
            after(@app_response)
          end
        else
          after_failure(error)
          throw(:error, error)
        end
        @app_response
      end

      def after(status)
        log['status_code']  = status.to_s
        log['completed_in'] = "#{((Time.now.utc - start_time) * 1000).round(2)}ms"
        logger.info log
      end

      #
      # Helpers
      #

      def after_failure(error)
        log['errors'] = %Q(Error: #{error[:message]}) if error[:message]
        after(error[:status])
      end

      def parameters
        request_params = env['grape.request.params'].to_hash
        request_params.merge!(env['action_dispatch.request.request_parameters'] || {})
        if @options[:filter]
          @options[:filter].filter(request_params)
        else
          request_params
        end
      end

      def start_time
        @start_time ||= Time.now.utc
      end

      def application
        @application ||= @options[:application] || ''
      end

      def service
        @service ||= @options[:service] || ''
      end

      def logger
        @logger ||= @options[:logger] || ::Logger.new(STDOUT)
      end
    end
  end
end
