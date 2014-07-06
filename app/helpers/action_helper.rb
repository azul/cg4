module ActionHelper

  def action_list_for(subject)
    render subject.allowed_actions_for(current_user)
  end

  def link_to_action(action)
    text = t(action.translation_key)
    link_to text, action.url_options, action.html_options
  end

  def render_allowed_actions(&block)
    render allowed_actions(&block)
  end

  def allowed_actions
    factory = ActionFactory.new
    yield factory
    factory.select do |action|
      action.allowed_to? current_user
    end
  end

end

