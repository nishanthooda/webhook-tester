
class JobtestController < ApplicationController
    def test
        PrintJob.perform_later("hi")
        render(status: 200, json: "queued job")
    end
end