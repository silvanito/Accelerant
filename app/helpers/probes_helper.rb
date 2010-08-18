module ProbesHelper

  def render_probe(probe,replies)
    probe_return = "<div class='probe'>"
    probe_return = probe_return + "<em>#{User.find(probe.user_id).name } followed up with: </em>"
    #probe_return = probe_return + simple_format(probe.content)
    probe_return = probe_return + simple_format(Remo.new(probe.content).to_html)
    probe_return = probe_return + "</div>"

    if (probe.id == @follows_last.id) && !@project.lock
      probe_return = probe_return + "<br/>"
      probe_return = probe_return + link_to_remote('Follow Up', :url => {:controller => 'plain', :action => 'follow_up', :id => replies.id}, :update => "probe#{replies.id}")
    end
    return probe_return
  end
  
end
