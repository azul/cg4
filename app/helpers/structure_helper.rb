module StructureHelper

  def section(subject, &block)
    div_for subject, class: "row", &block
  end

  def title(subject)
    render 'structure/title', subject: subject
  end

  def alert(messages)
    render 'structure/alert', messages: messages
  end

  def intro(subject)
    render 'structure/intro', subject: subject
  end

  def actions(subject)
    render 'structure/actions', subject: subject
  end

end
