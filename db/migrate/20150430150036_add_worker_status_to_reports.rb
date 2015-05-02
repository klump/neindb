class AddWorkerStatusToReports < ActiveRecord::Migration
  def change
    add_column :reports, :parser_status, :string
  end
end
