module Exportable
  extend ActiveSupport::Concern

  module ClassMethods

    def to_csv(list, opts = {})

      CSV.generate do |csv|
        cols = column_names - (opts[:skip_cols] || [])
        csv << cols
        list.each { |x| csv << x.attributes.values_at(*cols) }
      end

    end

  end

end
