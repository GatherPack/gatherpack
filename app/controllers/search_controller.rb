class SearchController < ApplicationController
  def index
    scope = params[:scope].presence || "people events teams badges tokens announcements time_clock_periods hooks"
    @results = search(params[:q], scope)
  end

  def combo
    scope = params[:scope].presence || "people events teams badges tokens announcements time_clock_periods hooks"
    attr = case params[:attribute]
    when /_nid$/
      :neat_id
    when /_id$/
      :id
    else
      params[:attribute].to_sym
    end
    @results = search(params[:q], scope).map { |e| { record: e, display: e.identifier_name, value: e.send(attr) } }
  end

  private

  def search(q, scope)
    scope = scope.split(" ").map(&:strip).uniq
    results = []
    results += policy_scope(Person).ransack(first_name_or_last_name_or_display_name_cont: params[:q]).result(distinct: true) if scope.include?("people")
    if scope.include?("managed_people")
      if current_user.admin?
        results += policy_scope(Person).ransack(first_name_or_last_name_or_display_name_cont: params[:q]).result(distinct: true)
      else
        results += current_user.person.all_managed_people.ransack(first_name_or_last_name_or_display_name_cont: params[:q]).result(distinct: true)
      end
    end
    team_people_ids = scope.select { |s| s.start_with?("team_people:") }.map { |s| s.split(":").last }
    team_people_ids.each do |team_id|
      results += policy_scope(Team.find(team_id).all_people).ransack(first_name_or_last_name_or_display_name_cont: params[:q]).result(distinct: true)
    end
    results += Person.where(id: current_user.person.id).ransack(first_name_or_last_name_or_display_name_cont: params[:q]).result(distinct: true) if scope.include?("me")
    results += policy_scope(Event).ransack(name_or_description_cont: params[:q]).result(distinct: true) if scope.include?("events")
    results += policy_scope(Team).ransack(name_cont: params[:q]).result(distinct: true) if scope.include?("teams")
    results += current_user.person.all_managed_teams.ransack(name_cont: params[:q]).result(distinct: true) if scope.include?("managed_teams")
    results += policy_scope(Badge).ransack(name_or_description_cont: params[:q]).result(distinct: true) if scope.include?("badges")
    results += policy_scope(Token).ransack(value_cont: params[:q]).result(distinct: true) if scope.include?("tokens")
    results += policy_scope(Announcement).ransack(name_or_content_cont: params[:q]).result(distinct: true) if scope.include?("announcements")
    results += policy_scope(TimeClockPeriod).ransack(name_cont: params[:q]).result(distinct: true) if scope.include?("time_clock_periods")
    results += policy_scope(Ledger).ransack(name_cont: params[:q]).result(distinct: true) if scope.include?("ledgers")
    results += policy_scope(Hook).ransack(name_cont: params[:q]).result(distinct: true) if scope.include?("hooks")
    results.uniq.sort_by! { |e| e.identifier_name.downcase }
  end
end
