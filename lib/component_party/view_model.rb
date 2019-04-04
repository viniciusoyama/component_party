module ComponentParty
  class ViewModel
    def initialize(**args)
      generate_methods_from_hash(args)
    end

    private

    def generate_methods_from_hash(hash)
      hash.each do |key, val|
        define_singleton_method key.to_sym do
          val
        end
      end
    end
  end
end
