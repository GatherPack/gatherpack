class SearchController < ApplicationController
  def index
    scope = params[:scope].presence || "people events teams badges tokens announcements"
    @results = search(params[:q], scope)
  end

  def combo
    scope = params[:scope].presence || "people events teams badges tokens announcements"
    @results = search(params[:q], scope).map { |e| { record: e, display: e.identifier_name, value: e.to_global_id.to_s } }.first(12)
  end

  private

  def search(q, scope)
    results = []
    results += policy_scope(Person).ransack(first_name_or_last_name_or_display_name_cont: params[:q]).result(distinct: true) if scope.include?("people")
    results += policy_scope(Event).ransack(name_or_description_cont: params[:q]).result(distinct: true) if scope.include?("events")
    results += policy_scope(Team).ransack(name_cont: params[:q]).result(distinct: true) if scope.include?("teams")
    results += policy_scope(Badge).ransack(name_or_description_cont: params[:q]).result(distinct: true) if scope.include?("badges")
    results += policy_scope(Token).ransack(value_cont: params[:q]).result(distinct: true) if scope.include?("tokens")
    results += policy_scope(Announcement).ransack(name_or_content_cont: params[:q]).result(distinct: true) if scope.include?("announcements")

    results += policy_scope(Hook).ransack(name_cont: params[:q]).result(distinct: true) if scope.include?("hooks")
    results
  end
end
