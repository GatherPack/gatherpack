class AbstractVersion < PaperTrail::Version
  include PaperTrail::VersionConcern
  self.abstract_class = true
  connects_to database: { writing: :versions, reading: :versions }
end
