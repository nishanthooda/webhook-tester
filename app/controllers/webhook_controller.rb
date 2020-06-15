require "awesome_print"
require "rainbow"

class WebhookController < ApplicationController
    WEBHOOK_HEADERS = ["HTTP_USER_AGENT", "CONTENT_TYPE", "HTTP_X_GITHUB_EVENT", "HTTP_X_GITHUB_DELIVERY", "HTTP_X_HUB_SIGNATURE"]

    before_action :verify_signature!
    before_action :print_headers_and_body
    before_action :verify_is_merge

    def create
        pr_url = payload['pull_request']['url']
        pr_author_handle = payload['pull_request']['user']['login']
        pr_title = payload['pull_request']['title']
        repo_owner_email = payload['repository']['owner']['email']
        puts payload['repository']['owner']
        puts pr_url
        puts pr_author_handle
        puts pr_title
        puts repo_owner_email
        EmailMergedJob.perform_later(pr_url, pr_author_handle, pr_title, repo_owner_email)
        render(status: 200, json: "gotcha")
    end

    private

    def payload
      params['webhook']
    end

    def verify_is_merge
        return unless ENV['WEBHOOK_MODE'].include? 'merge'
        is_merge = request.headers['HTTP_X_GITHUB_EVENT'] == 'pull_request' && payload['action'] == 'closed' && payload['pull_request']['merged']
        render(status: 200, json: "gotcha not PR merge") unless is_merge
    end

    def print_headers_and_body
        return unless ENV['WEBHOOK_MODE'].include? 'print'
        newline
        puts Rainbow("~~~~~~~~~~~ webhook arriving for event: #{request.headers["HTTP_X_GITHUB_EVENT"]} ~~~~~~~~~~").cyan
        newline

        WEBHOOK_HEADERS.each do |header|
            puts "#{header}: #{request.headers[header]}"
        end

        newline
        newline

        ap payload.to_unsafe_h

        newline
        puts Rainbow("----------------done outputting-----------------").cyan
        newline
    end

    def newline
        puts "\n"
    end

    def verify_signature!
        secret = ENV["WEBHOOK_SECRET"]

        signature = 'sha1='
        signature += OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, request.body.read)

        unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
            guid = request.headers["HTTP_X_GITHUB_DELIVERY"]
            render(status: 400, json: "secret verification failed for #{guid}")
        end
    end  
end
