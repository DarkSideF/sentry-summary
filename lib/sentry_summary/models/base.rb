module SentrySummary
  module Models
    class Base < Hashie::Mash
      include Hashie::Extensions::IndifferentAccess
      include Hashie::Extensions::IgnoreUndeclared
      include Hashie::Extensions::Coercion
    end
  end
end
