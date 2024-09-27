<% module_namespacing do -%>
class <%= controller_class_name %>Controller < InternalController
  before_action :set_<%= singular_table_name %>, only: %i[ show edit update destroy ]

  # GET <%= route_url %>
  def index
    @q = policy_scope(<%= class_name %>).ransack(params[:q])
    @<%= plural_table_name %> = @q.result(distinct: true).page(params[:page])
  end

  # GET <%= route_url %>/1
  def show
  end

  # GET <%= route_url %>/new
  def new
    @<%= singular_table_name %> = authorize <%= orm_class.build(class_name) %>
  end

  # GET <%= route_url %>/1/edit
  def edit
  end

  # POST <%= route_url %>
  def create
    @<%= singular_table_name %> = authorize <%= orm_class.build(class_name, "#{singular_table_name}_params") %>

    if @<%= orm_instance.save %>
      redirect_to <%= redirect_resource_name %>, notice: <%= %('#{human_name} was successfully created.') %>
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT <%= route_url %>/1
  def update
    if @<%= orm_instance.update("#{singular_table_name}_params") %>
      redirect_to <%= redirect_resource_name %>, notice: <%= %('#{human_name} was successfully updated.') %>, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    @<%= orm_instance.destroy %>
    redirect_to <%= index_helper %>_url, notice: <%= %('#{human_name} was successfully destroyed.') %>, status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = authorize policy_scope(<%= class_name %>).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
      params.fetch(:<%= singular_table_name %>, {})
      <%- else -%>
      params.require(:<%= singular_table_name %>).permit(<%= permitted_params %>)
      <%- end -%>
    end
end
<% end -%>
