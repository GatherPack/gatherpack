class AbstractVersion < PaperTrail::Version
  include PaperTrail::VersionConcern
  self.abstract_class = true
end
