class MergedMailer < ApplicationMailer
    def merged_email
        @title = params[:title]
        @repo_owner_email = params[:owner_email]
        @url = params[:url]
        @handle = params[:author_handle]
        puts "sending to nishuhooda99"
        mail(to: 'nishuhooda99@gmail.com', subject: 'A PR was merged into your repository')
    end
end
