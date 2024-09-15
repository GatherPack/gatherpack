class SearchController < ApplicationController
  def index
    people = policy_scope(Person).ransack(first_name_or_last_name_or_display_name_cont: params[:q]).result(distinct: true)
    events = policy_scope(Event).ransack(name_or_description_cont: params[:q]).result(distinct: true)
    teams = policy_scope(Team).ransack(name_cont: params[:q]).result(distinct: true)
    badges = policy_scope(Badge).ransack(name_or_description_cont: params[:q]).result(distinct: true)
    tokens = policy_scope(Token).ransack(value_cont: params[:q]).result(distinct: true)
    announcements = policy_scope(Announcement).ransack(name_or_content_cont: params[:q]).result(distinct: true)
    @results = people + events + teams + badges + announcements + tokens
  end
end
