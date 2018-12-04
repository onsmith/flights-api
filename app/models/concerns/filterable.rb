module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filtering_params)
      query = self.where(nil)
      if filtering_params.respond_to?(:each)
        filtering_params.each do |key, value|
          query = query.public_send(key, value) if value.present?
        end
      end
      query
    end

    def allow_filter_by(field)
      field = field.to_s
      scope field + '_gt', -> (t) { where field + " > ?", t }
      scope field + '_ge', -> (t) { where field + " >= ?", t }
      scope field + '_lt', -> (t) { where field + " < ?", t }
      scope field + '_le', -> (t) { where field + " <= ?", t }
      scope field + '_eq', -> (t) { where field + " = ?", t }
      scope field + '_ne', -> (t) { where field + " != ?", t }
    end
  end
end