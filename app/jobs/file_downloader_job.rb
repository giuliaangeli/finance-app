# class FileDownloaderJob < ApplicationJob
#     queue_as :default
  
#     def perform(current_user, header, table)
#       table.each do |row|
#         transaction_hash = Hash[header.zip(row)]
#         transaction_hash["tag_id"] = Tag.find_by(subcategory: transaction_hash["tag_id"]).id
#         transaction_hash["user_id"] = current_user
#       end
#     end
#   end