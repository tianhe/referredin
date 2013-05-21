module NetworkHelper
  def order_by_count attribute
    group(attribute.to_sym).select("#{attribute} AS facet, count(*) AS count").order('count desc')
  end
end