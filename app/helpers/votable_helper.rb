module VotableHelper
  def votable_tag(votable, options = {})
    size = options[:size] || "btn-m"
    options[:style] ||= :votable
    #Posible sizes: btn-xs, btn-s, btn-m, btn-l
    #For more information on sizes search bootstrap components.
    path_up = url_for([:vote_up, votable])
    path_down = url_for([:vote_down, votable])
    render partial: "votable/votable", locals: {path_up: path_up, path_down: path_down, votable: votable, size: size, style: options[:style]}
  end

  def vote_up(path, votable, user, size = "btn-m", options = {})
    locals = {path: path, votable: votable, user: user, size: size, options: options}
    case options[:style]
      when :arrows
        render partial: 'votable/styles/arrow_up', locals: locals
      when :agreable
        render partial: 'votable/styles/agree', locals: locals
      else #Including default style :votable
        render partial: 'votable/styles/votable_up', locals: locals
    end
  end

  def vote_down(path, votable, user, size = "btn-m", options = {})
    locals = {path: path, votable: votable, user: user, size: size, options: options}
    case options[:style]
      when :arrows
        render partial: 'votable/styles/arrow_down', locals: locals
      when :agreable
        render partial: 'votable/styles/disagree', locals: locals
      else #Including default style :votable
        render partial: 'votable/styles/votable_down', locals: locals
    end
  end

end