module FiledHelper
  def destroy_file_path(file, *params)
    path = "/#{fileable_resource(file)}/#{file.record.id}/destroy_file"
    if params
      path += '?'
      params[0].each_pair do |key, value|
        path += "#{key}=#{value}&"
      end
    end

    path
  end

  private

  def fileable_resource(file)
    file.record.class.model_name.route_key
  end
end
