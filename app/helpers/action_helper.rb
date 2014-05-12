module ActionHelper

  def link_to_action(action)
    text = t(action.translation_key)
    link_to text, action.url_options, action.html_options
  end

end

