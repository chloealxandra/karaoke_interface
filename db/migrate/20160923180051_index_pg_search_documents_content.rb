class IndexPgSearchDocumentsContent < ActiveRecord::Migration[5.0]
  def change
    add_index :pg_search_documents, :content
  end
end
