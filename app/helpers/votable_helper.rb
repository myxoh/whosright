module VotableHelper
  def votable_tag(votable, size = "btn-m", style = :regular)
    #Posible sizes: btn-xs, btn-s, btn-m, btn-l
    #For more information on sizes search bootstrap components.
    path_up = url_for([:vote_up, votable])
    path_down = url_for([:vote_down, votable])
    render partial: "partials/votable", locals: {path_up: path_up, path_down: path_down, votable: votable, size: size, style: style}
  end

  def vote_up(path, votable, user, size = "btn-m", style = :regular)
    custom_class="glow"
    custom_class+=(Vote.casted_up?(votable: votable, user: user)) ? " good" : ""
    button = link_to span("", class: "glyphicon glyphicon glyphicon-thumbs-up"), path, remote: true, class: "btn btn-success vote_up #{size}"
    content_tag(:div, button, class: custom_class, id: "vote_glowable_up_"+votable.class.name+"_"+votable.id.to_s)
  end

  def vote_down(path, votable, user, size = "btn-m", style = :regular)
    custom_class="glow"
    custom_class+=(Vote.casted_down?(votable: votable, user: user)) ? " bad" : ""
    button=link_to span("", class: "glyphicon glyphicon glyphicon-thumbs-down"), path, remote: true, class: "btn btn-danger vote_down #{size}"
    content_tag(:div, button, class: custom_class, id: "vote_glowable_down_"+votable.class.name+"_"+votable.id.to_s)
  end

  def get_style_from_hash(size = "btn-m")

  end

end