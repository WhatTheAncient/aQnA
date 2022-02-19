module LinkedHelper
  def destroy_link_path(link, *params)
    path = "/#{linkable_resource(link)}/#{link.linkable.id}/destroy_link"
    if params
      path += '?'
      params[0].each_pair do |key, value|
        path += "#{key}=#{value}&"
      end
    end

    path
  end

  private

  def linkable_resource(link)
    link.linkable.class.model_name.route_key
  end
end
