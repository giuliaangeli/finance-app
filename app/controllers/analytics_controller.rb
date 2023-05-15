class AnalyticsController < TransactionsController
    before_action :set_transactions
    def index
        subcategory_review
        category_review
        mouth_review
        category_data_chart
    end

    def mouth_review
        @line_chart = @transactions.group_by { |t| [t.input_type, t.date.strftime("%Y-%m")] }
        @line_chart = @line_chart.map { |(input_type, date), transactions|
          { name: input_type, data: { date => transactions.sum(&:value) } }
        }.group_by { |data| data[:name] }.map { |name, values|
          { name: name, data: values.flat_map { |data| data[:data].to_a } }
        }
    end

    def subcategory_review
        @subcategory_data = @transactions.find_by_sql(["SELECT transactions.value, tags.* FROM transactions INNER JOIN tags ON tags.id = transactions.tag_id WHERE date > ? AND date < ?", Date.today.at_beginning_of_month, Date.today]).group_by { |t| [t.subcategory, t.category] }
        @subcategory_data = @subcategory_data.map { |(subcategory, category), transactions|
            { name: subcategory, data: { category => transactions.sum(&:value) } }
            }.group_by { |data| data[:name] }.map { |name, values|
                { name: name, data: values.flat_map { |data| data[:data].to_a } }
            }
    end

    def category_data_chart
        @category_data_chart = @transactions.find_by_sql("SELECT transactions.value, transactions.date, tags.* FROM transactions INNER JOIN tags ON tags.id = transactions.tag_id").group_by { |t| [t.category, t.date.strftime("%m/%Y")] }
        @category_data_chart = @category_data_chart.map { |(category, date), transactions|
            { name: category, data: { date => transactions.sum(&:value) } }
            }.group_by { |data| data[:name] }.map { |name, values|
                { name: name, data: values.flat_map { |data| data[:data].to_a } }
            }
    end

    def category_review
        @category_data = @transactions.find_by_sql(["SELECT transactions.value, transactions.date, tags.* FROM transactions INNER JOIN tags ON tags.id = transactions.tag_id WHERE date > ? AND date < ?", Date.today.at_beginning_of_month, Date.today]).group_by { |t| [t.category] }
        @category_data = @category_data.map do |category, transactions|
            [category, transactions.sum(&:value)]
        end
    end

    private
    def set_transactions
        @transactions = @user.transactions.all
    end
end
