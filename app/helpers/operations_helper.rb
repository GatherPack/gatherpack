module OperationsHelper
  def operation_button(operation)
    if policy(operation).run?
      tool_button(operation.icon, operation.name, "", run_operation_path(operation), method: :post, style: "color: #{contrasting_color(operation.color)}; background-color: #{operation.color};")
    end
  end
end
