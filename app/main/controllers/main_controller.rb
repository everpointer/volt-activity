# By default Volt generates this controller for your Main component
class MainController < Volt::ModelController
  model :store

  def index
    # Add code for when the index view is loaded
    Document.ready? do
      %x{
        $('#scratch_pad').wScratchPad({
          size        : 10,
          fg          : '#cacaca',
          bg          : '/assets/images/winner.png',
          cursor      : 'crosshair',
          scratchMove : function(e, percent) {
            if(percent > 60) this.clear();
          }
        });
      }
    end
  end

  def about
    # Add code for when the about view is loaded
  end

  def activity
    # activity index
  end

  def share
    if Volt.user
      # handle activity shared path, current Volt user is visitor
      visit = {owner: params._owner, activity_index: params._index.to_s, visitor: Volt.user._email}
      if store._activity_visits.find(visit).size > 0
        _activity_visits << visit
      else
        page._already_visited = true
      end
    end
  end

  private

  # The main template contains a #template binding that shows another
  # template.  This is the path to that template.  It may change based
  # on the params._controller and params._action values.
  def main_path
    params._controller.or('main') + '/' + params._action.or('index')
  end

  # Determine if the current nav component is the active one by looking
  # at the first part of the url against the href attribute.
  def active_tab?
    url.path.split('/')[1] == attrs.href.split('/')[1]
  end

  # activity path for current user
  def activity_share_path
    url_for(action: 'share', index: 1, owner: Volt.user._email)
  end
end
