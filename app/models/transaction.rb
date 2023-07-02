class Transaction < ApplicationRecord
    belongs_to :user, optional: false
    belongs_to :tag, foreign_key: "tag_id"
    validates :input_type, :date, :value, :installments, :user, presence:true
    
    # def self.to_csv
    #     FileDownloaderJob.new.perform(all)
    # end
end
