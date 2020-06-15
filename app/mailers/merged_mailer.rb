class MergedMailer < ApplicationMailer
    def merged_email
        @title = params[:title]
        @repo_owner_email = params[:owner_email]
        @url = params[:url]
        @handle = params[:author_handle]
        mail(to: repo_owner_email, subject: 'A PR was merged into your repo')
    end
end
