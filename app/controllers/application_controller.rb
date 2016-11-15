class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def logged_in?
    !!session[:user_id]
  end

  def filter_index(klass)
    filter_q = ''
    filter_requests = []
    klass.search_fields.each do |field_symbol|
      if params[field_symbol].present?
        filter_q += " AND " unless filter_q.blank?
        if field_symbol.to_s.ends_with? '_id'
          filter_q += "#{field_symbol} = ?"
          filter_requests << params[field_symbol]
        elsif klass.columns_hash[field_symbol.to_s].type == :integer
          gle = params["#{field_symbol}_gle"]
          gle_to_sql = { 'Greater than' => '>', 'Less than' => '<', 'Equals' => '=' }
          filter_q += "#{field_symbol} #{gle_to_sql[gle]} ?"
          filter_requests << params[field_symbol].to_i
        else
          filter_q += "lower(#{klass.table_name}.#{field_symbol}) LIKE ?"
          filter_requests << "%#{params[field_symbol].downcase}%"
        end
      elsif klass.columns_hash[field_symbol.to_s].type == :datetime
        begin
          if params["#{field_symbol}_gte"].present?
            filter_q += " AND " unless filter_q.blank?
            search_date = params["#{field_symbol}_gte"].gsub("/","-")
            date = Date.strptime(search_date, "%m-%d-%Y")
            filter_q += "#{field_symbol} >= ?"
            filter_requests << date
          end
          if params["#{field_symbol}_lte"].present?
            filter_q += " AND " unless filter_q.blank?
            search_date = params["#{field_symbol}_lte"].gsub("/","-")
            date = Date.strptime(search_date, "%m-%d-%Y")
            filter_q += "#{field_symbol} <= ?"
            filter_requests << date
          end
        rescue
          flash[:error] = "Invalid Date Requested"
        end
      end
    end
    return [filter_q, filter_requests]
  end
end
