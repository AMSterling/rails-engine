module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filtered(scope_params)
      results = self.where(nil)
      scope_params.each do |key, value|
        results = results.public_send("filter_by_#{key}", value) if !value.empty? && !value.to_f.negative?
      end
      results
    end
  end
end
