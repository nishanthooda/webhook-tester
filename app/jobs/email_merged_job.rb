class EmailMergedJob < ApplicationJob
    queue_as :default
  
    def perform(*args)
        url, author_handle, title, owner_email = args
        puts "performing job for PR: #{title}"
        MergedMailer.with(url: url, author_handle: author_handle, title: title, owner_email: owner_email).merged_email.deliver_now
        puts "done job for PR: #{title}"
    end
  end
  