class RelationshipsController < ApplicationController
  before_action :set_person

  def new
    @relationship = Relationship.new
  end

  def create
    @relationship = Relationship.new(relationship_params)
    @relationship.created_by = current_user.person
    @relationship.node_occupant = @person
    @relationship.reify
    if @relationship.parent.present? && @relationship.child.present?
      authorize @relationship
      if @relationship.save
        redirect_to @person
      else
        render :new, status: 422
      end
    else
      render :new, status: 428
    end
  end

  def reverse
    @relationship = Relationship.find(params[:id])
    @relationship.reverse
    @relationship.created_by = current_user.person
    if @relationship.save
      redirect_to relationships_person_path(@person), notice: "Relationship was successfully reversed."
    else
      redirect_to relationships_person_path(@person), notice: "Relationship was not successfully reversed."
    end
  end

  def destroy
    @relationship = Relationship.find(params[:id])
    @relationship.destroy
    redirect_to relationships_person_path(@person), notice: "Relationship was successfully destroyed."
  end

  private
  def set_person
    @person = Person.find(params[:person_id])
  end

  def relationship_params
    params.require(:relationship).permit(:parent_id, :child_id, :relationship_type_id, :start_node)
  end
end
