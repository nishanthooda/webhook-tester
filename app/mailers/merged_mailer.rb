class MergedMailer < ApplicationMailer
    def merged_email
        @title = params[:title]
        @repo_owner_email = params[:owner_email]
        @url = params[:url]
        @handle = params[:author_handle]
        puts "repo_ownder_email is #{@repo_owner_email}"
        mail(to: 'nishanthooda@github.com', subject: 'A PR was merged into your repo')
    end
end
