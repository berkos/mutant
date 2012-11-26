module Mutant
  class Strategy 
    include AbstractType

    # Kill mutation
    #
    # @param [Mutation]
    #
    # @return [Killer]
    #
    # @api private
    #
    def self.kill(mutation)
      killer.new(self, mutation)
    end

    def self.killer
      self::KILLER
    end

    class Static < self
      class Fail < self
        KILLER = Killer::Static::Fail
      end

      class Success < self
        KILLER = Killer::Static::Success
      end
    end

    class Rspec < self
      KILLER = Killer::Rspec

      class DM2 < self

        def self.filename_pattern(mutation)
          name = mutation.subject.context.scope.name

          append = mutation.subject.matcher.kind_of?(Matcher::Method::Singleton) ? '/class_methods' : ''

          path = Inflector.underscore(name)

          "spec/unit/#{path}#{append}/*_spec.rb"
        end

      end

      class Unit < self
        def self.filename_pattern(mutation)
          'spec/unit/**/*_spec.rb'
        end
      end

      class Full < self
        def self.filename_pattern(mutation)
          'spec/**/*_spec.rb'
        end
      end
    end
  end
end