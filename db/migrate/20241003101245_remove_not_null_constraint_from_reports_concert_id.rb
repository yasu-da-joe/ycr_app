class RemoveNotNullConstraintFromReportsConcertId < ActiveRecord::Migration[7.2]
  def change
    change_column_null :reports, :concert_id, true
  end
end
