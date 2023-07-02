# class FileDownloaderJob < ApplicationJob
#     queue_as :default
#     def perform(all)
#         attributes = %w{input_type date value installments tag}
#         CSV.generate(headers: true) do |csv|
#             csv << attributes
#             all.each do |transactions|
#                 csv << transactions.attributes.values_at(*attributes)
#             end
#         end
#     end
# end
