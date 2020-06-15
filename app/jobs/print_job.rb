class PrintJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "Started job: #{args[0]}"
    sleep 2
    puts "Finished job"
  end
end
