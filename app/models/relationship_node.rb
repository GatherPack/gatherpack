class RelationshipNode
    attr_accessor :label, :other, :relationship_type, :node

    def self.all
        RelationshipType.all.reduce([]) do |acc, rt| 
            acc << RelationshipNode.new(rt, 'c')
            acc << RelationshipNode.new(rt, 'p')
        end
    end

    def initialize(rt, node)
        @relationship_type = rt
        if node =~ /^c/i
            @node = 'c'
            @label = rt.child_label
            @other = rt.parent_label
        elsif node =~ /^p/i
            @node = 'p'
            @label = rt.parent_label
            @other = rt.child_label
        else
            raise ArgumentError
        end
    end

    def to_s
        "#{label} of #{other}"
    end

    def to_id
        "#{relationship_type.id}:#{node}"
    end
end