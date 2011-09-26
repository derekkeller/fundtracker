module Admin::UsersHelper

  def boolean_icon(b)
    if b
      image_tag('accept.png')
    end
  end
end
