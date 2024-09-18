class ScaffoldGenerator < Rails::Generators::NamedBase
  hook_for :scaffold, in: :rails, default: true, type: :boolean
  hook_for :policy, in: :policy, type: :boolean, default: true
  hook_for :breadcrumb, in: :breadcrumb, type: :boolean, default: true
end
