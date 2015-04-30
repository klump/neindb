class AddWorkerStatusToReports < ActiveRecord::Migration
  def change
    add_column :reports, :worker_status, :string
  end
end
