module ApplicationHelper
  def nh(n, p=0)
    a = number_to_currency(n, :precision => p, :unit => '', :delimiter => ',') 
    b = a == 'NaN' ? 0 : a
  end
  
  def ph(n, p=0)
    a = number_to_percentage(n, :precision => p)
    b = a == 'NaN%' ? '0%' : a
  end
  
  def find_udc_item(udc, lines)
    a = lines.detect do |h|
          udc.id == h['id']
    end
    a['positive'] - a['negative']
  rescue
    0.0
  end
  
  def find_udc_item_percent_of_sales(udc, lines, total_revenue)
    return 0.0 if lines.nil?
    a = lines.detect do |h|
          udc.id == h['id']
    end
    ans = a['positive'] - a['negative']
    puts "####################hello"
    puts "#{ans} / #{total_revenue.to_f}"
    puts "####################"
    (ans / total_revenue.to_f)
  rescue NoMethodError
    0.0
  end
  
  def available_funds(o)
    o.funds.map {|f| [f.name, f.id]}.unshift(['All Funds',''])
  rescue
    Fund.all.map {|f| [f.name, f.id]}.unshift(['All Funds',''])
  end
  
  def available_companies(o)
    o.companies.map { |c| [c.name, c.id]}.unshift(['All Companies',''])
  rescue
    Company.all.map { |c| [c.name, c.id]}.unshift(['All Companies',''])
  end
  
end
